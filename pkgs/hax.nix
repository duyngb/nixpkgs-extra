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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "OleksandrChekhovskyi";
    repo = "hax";
    tag = "v${final.version}";
    hash = "sha256-KdXnOb/JLEdPgZOliKU0PHNL04jxgUpfeukKIuGmoKo=";
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
