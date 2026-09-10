{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

stable.jujutsu.overrideAttrs (final: rec {
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-nqMd9kj6TH/6kTZ8a9XDPBESwCIOMa7c/0TgbEXoo3o=";
  };

  cargoHash = "sha256-rt3mq7+Z+7Z1Y+XUWva+UsrDcVeZs6VjXnhAL0iyP20=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
  doInstallCheck = false;
})
