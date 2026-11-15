{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  fontconfig,
  freetype,
  krb5,
  libclang,
  libxcb,
  libxkbcommon,
  openssl,
  pkg-config,
  wayland,
  zlib,
}:

rustPlatform.buildRustPackage (f: {
  pname = "tty7";
  version = "26.10.0";

  src = fetchFromGitHub {
    owner = "l0ng-ai";
    repo = "tty7";
    tag = "v${f.version}";
    hash = "sha256-+J6kkg27aqQb/7/rcOf6NJLQ7ICHbUcaW4PDsJiC0ho=";
  };

  cargoHash = "sha256-VzQsEEvrXZDBp9rqTZsn9pbWKMgX0Z3eC6P8Ag1LZNs=";

  patches = [
    ./01-nix-default-override.patch
  ];

  buildInputs = [
    libclang
    fontconfig
    freetype
    krb5
    libxcb
    libxkbcommon
    openssl
    wayland
    zlib
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  postInstall = ''
    install -Dm644 assets/logo.svg $out/share/icons/hicolor/scalable/apps/tty7.svg
    install -Dm644 assets/logo@256.png $out/share/icons/hicolor/256x256/apps/tty7.png
    mkdir -p $out/share/applications
    substituteAll ${./tty7.desktop} $out/share/applications/tty7.desktop
  '';

  doCheck = false;

  meta = {
    license = lib.licenses.apsl20;
    mainProgram = "tty7";
  };
})
