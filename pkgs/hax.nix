{
  lib,
  stdenv,
  fetchFromGitHub,

  curl,
  jansson,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (final: {
  pname = "hax";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "OleksandrChekhovskyi";
    repo = "hax";
    tag = "v${final.version}";
    hash = "sha256-ZDGRSKZtWcQwbSB5FWpmSvBPHuoc53RHm2JBxSDb11c=";
  };

  buildInputs = [
    curl
    jansson
    meson
    ninja
    pkg-config
  ];

  meta = {
    license = lib.licenses.mit;
  };
})
