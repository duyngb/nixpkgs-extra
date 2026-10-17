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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "OleksandrChekhovskyi";
    repo = "hax";
    tag = "v${final.version}";
    hash = "sha256-U6tLkRBwT/5gxK1O9Hu+hGJbV+39vEczD22l9c1yYDs=";
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
