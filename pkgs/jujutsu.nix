{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

(stable.jujutsu.override { inherit rustPlatform; }).overrideAttrs (final: rec {
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-FXbQyKmh/CG/TsRi9yq9L8bVbQ39u6PRLZIet3d/bjA=";
  };

  cargoHash = "sha256-VvgGnAPCvcBmbP2Aw7tdJcjfo+011u4Pqx1pKiiWISA=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
})
