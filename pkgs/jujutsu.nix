{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

(stable.jujutsu.override { inherit rustPlatform; }).overrideAttrs (final: rec {
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-PBrsNHywOUEiFyyHW6J4WHDmLwVWv2JkbHCNvbE0tHE=";
  };

  cargoHash = "sha256-jOklgYw6mYCs/FnTczmkT7MlepNtnHXfFB4lghpLOVE=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
  doInstallCheck = false;
})
