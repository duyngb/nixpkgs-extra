{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

(stable.jujutsu.override { inherit rustPlatform; }).overrideAttrs (final: rec {
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-HGMzNXm6vWKf/RHPwB/soDqxAvCOW1J6BPs0tsrEuTI=";
  };

  cargoHash = "sha256-jai0FNuCUcgN+ZmmYgbFrMK1Z1vcv21wALkEb74h7H0=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
})
