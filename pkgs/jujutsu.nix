{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

stable.jujutsu.overrideAttrs (final: rec {
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-wAefhpNP4ErCTTjZADpvTDk2of/XKP/MoXl6fpG7/fA=";
  };

  cargoHash = "sha256-b7/5vkO6GNX8qzJr4NcxtLZVLDc6NOMrOU4dE6LOFoE=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
  doInstallCheck = false;
})
