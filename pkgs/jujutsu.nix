{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

(stable.jujutsu.override { inherit rustPlatform; }).overrideAttrs (final: rec {
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-rcmiBDDQaJYpESJt/gWkcitWtcvQosDY9pUbX5YpFjA=";
  };

  cargoHash = "sha256-WqM9NJQIrbu+ynhh1pq9nXjoL30A56vIE2lHi7ZUQoc=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
  doInstallCheck = false;
})
