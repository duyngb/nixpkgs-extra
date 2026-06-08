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
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "jnsahaj";
    repo = "lumen";
    tag = "v${final.version}";
    hash = "sha256-EoxMYlWHmuprjjhvj3GyCxGDIcT/d+JMda9j75pqs+k=";
  };

  cargoHash = "sha256-qTFRfy+Wutee5SbaMaqcYjXgr6xZKYYBIuyVA7jAGiY=";

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
