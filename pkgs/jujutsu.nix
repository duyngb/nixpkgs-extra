{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

stable.jujutsu.overrideAttrs (final: rec {
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-XgBq2ZN34iWlwKVgW7Syr46KUdt7pJuSDd/J6QWJwwQ=";
  };

  cargoHash = "sha256-bEvpTd+FAHrD+CZN7+AuCuThyJ5LtufQR7OrGpjrWK0=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
  doInstallCheck = false;
})
