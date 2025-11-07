{
  lib,
  fetchFromGitHub,

  pkg-config,
  ncurses,

  makeRustPlatform,
  rust-bin,
}:

let
  version = "0.0.0-dev20241005";
  srcHash = "sha256-fgAwEtJqnKkBHy06HnEkUCO0/RwCaNXuLeAajf/Mo7M=";
  cargoHash = "sha256-cbDGG9otKT+Gxra0RGGJ578u9mMJk+jV0dyO2+d7j2w=";

  rust-bin-default = rust-bin.stable.latest.default;
  rustPlatform = makeRustPlatform {
    cargo = rust-bin-default;
    rustc = rust-bin-default;
  };
in

rustPlatform.buildRustPackage {
  inherit version cargoHash;
  pname = "ttyloop";

  src = fetchFromGitHub {
    owner = "gamma-delta";
    repo = "ttyloop";
    rev = "909d9dc8cac9f95f469f2f9b5f2df83c20103e78";
    hash = "${srcHash}";
  };

  doCheck = false;
  doInstallCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
  ];

  meta = {
    description = "Terminal clone of Loop by infinitygames.io";
    homepage = "https://github.com/gamma-delta/tty";
    license = lib.licenses.mit;
    mainProgram = "ttyloop";
  };
}
