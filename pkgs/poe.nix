{
  lib,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (final: {
  pname = "poe";
  version = "2.1.2";

  src = fetchurl {
    url = "https://git.sr.ht/~strahinja/poe/archive/v${final.version}.tar.gz";
    hash = "sha256-CCz74MIHQSrbcjphgO11V6Qu1TFWSYU0+TqMjaH8C/Y=";
  };

  patchPhase = ''
    sed -E 's/^PREFIX(.+)=.+$/PREFIX\1=/' config.Linux > config.mk
  '';

  installPhase = ''
    DESTDIR=$out make install
  '';

  env = {
    FALLBACKDATE = "19700101";
    FALLBACKVER = "${final.version}";
  };

  meta = {
    description = "tui PO file editor";
    homepage = "https://git.sr.ht/~strahinja/poe";
    license = lib.licenses.gpl3Only;
    mainProgram = "poe";
  };
})
