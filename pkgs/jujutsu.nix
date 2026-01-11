{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

(stable.jujutsu.override { inherit rustPlatform; }).overrideAttrs (final: rec {
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-KN8hukahS+/RowmQoaUrfxCKFT9YUhaIXzh84cBV1Ck=";
  };

  cargoHash = "sha256-rk3Qft9g67rG0m6rPd4d++wDM5RiRrJAIHdUOQhn9bg=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
})
