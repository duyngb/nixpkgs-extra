{
  lib,
  fetchFromGitHub,
  rustPlatform,

  pkg-config,
  wasm-pack,
  wasm-bindgen-cli,
}:

rustPlatform.buildRustPackage (final: {
  pname = "pipelight-rs";
  version = "0.11.0+20260123";

  src = fetchFromGitHub {
    owner = "crocuda";
    repo = "pipelight";
    rev = "478d67baa8d1db9d4620528d2e05d6d88a51c004";
    hash = "sha256-CZRypF3gr/u6kq/DFFuP6DmXP5PKnlzBTGVXB98kfY8=";
  };

  cargoHash = "sha256-8HqLVXoax1nZXWwzMU/o5Fe3ftGo/QdLPn99K6g182s=";

  buildInputs = [
    pkg-config
    wasm-pack
    wasm-bindgen-cli
  ];

  doCheck = false;
  doInstallCheck = false;

  meta = {
    description = "Tiny automation pipeline CLI";
    homepage = "https://pipelight.dev";
    license = lib.licenses.gpl2;
    mainProgram = "pipelight";
  };
})
