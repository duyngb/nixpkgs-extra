{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "tty8";
  version = "dev-20150613";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tty8";
    rev = "cfac161b6b7ecbb8c68dfdba6226862c029b43ed";
    hash = "sha256-N/oTk6N47Bsh6Gk0wbiuoUi7UFEQI/pTZliqhr3ygc8=";
  };

  doCheck = false;
  doInstallCheck = false;

  installPhase = ''
    make install DESTDIR=$out BIN_DIR=/bin MAN_DIR=/share/man DOC_DIR=/share/doc
  '';

  meta = {
    description = "A suckless terminal multiplexer";
    license = lib.licenses.mit;
  };
}
