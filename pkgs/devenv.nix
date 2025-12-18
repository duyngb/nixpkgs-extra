{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

(stable.devenv.override { inherit rustPlatform; }).overrideAttrs (final: rec {
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    tag = "v${version}";
    hash = "sha256-8Ivbm9ltg0hUGQYMuRDOI8hbHUzqB9xKZ9ubKAzzwE8=";
  };

  cargoHash = "sha256-mMmobDZeNqrByowwrDXojVnHeUyC/YbhERpF8iOCZ0s=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
})
