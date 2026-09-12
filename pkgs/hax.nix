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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "OleksandrChekhovskyi";
    repo = "hax";
    tag = "v${final.version}";
    hash = "sha256-d3gbxS+4q1UqtkGfcqF37yCKoQ4vprupgI2TN+3v4aM=";
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
