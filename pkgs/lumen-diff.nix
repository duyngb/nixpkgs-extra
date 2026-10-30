{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  perl,
}:

rustPlatform.buildRustPackage (final: {
  pname = "lumen-diff";
  version = "2.32.0";

  src = fetchFromGitHub {
    owner = "jnsahaj";
    repo = "lumen";
    tag = "v${final.version}";
    hash = "sha256-wTkg7NGCCON1P422q5/76rodIBqDeWIY07J4pRo8Q8k=";
  };

  cargoHash = "sha256-ZXw7KEvf1sUHWIM5R4Th2SmekTX6rGXznAq3mtcf3Zo=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  # NOTE (since v2.30.0): some tests are borked.
  doCheck = false;

  meta = {
    mainProgram = "lumen";
    license = lib.licenses.mit;
    homepage = "https://github.com/jnsahaj/lumen";
    description = "A nice TUI diff viewer";
  };
})
