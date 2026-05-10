{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

stable.jujutsu.overrideAttrs (final: rec {
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-id35e2kzyHyXCRy0aomkd1l0K7qzD0RnzdAzxKUGiso=";
  };

  cargoHash = "sha256-zWfdIac+SsNdfXAfD4NVTl7YfXzAlrK82KNduFgG1EA=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
  doInstallCheck = false;
})
