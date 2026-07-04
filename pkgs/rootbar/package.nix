{
  lib,
  stdenv,
  fetchhg,
  pkg-config,
  meson,
  ninja,
  gtk3,
  json_c,
  libpulseaudio,
  wayland,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "rootbar";
  version = "unstable-2025-01-01";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/rootbar";
    rev = "36333af9fd8d";
    sha256 = "sha256-CpORCSJyHZhcK14EhjxoPt/h0026NU5J/kicL1dX96o=";
  };

  patches = [
    ./0001-update-mpris-plugin.patch
    ./0002-allow-bar-s-output-to-be-omitted.patch
    ./0003-fix-crash-on-bad-mpris-messages.patch
    ./0004-fix-function-prototypes.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    json_c
    libpulseaudio
    wayland
  ];

  meta = with lib; {
    homepage = "https://hg.sr.ht/~scoopta/rootbar";
    description = "Bar for Wayland WMs";
    mainProgram = "rootbar";
    longDescription = ''
      Root Bar is a bar for wlroots based wayland compositors such as sway and
      was designed to address the lack of good bars for wayland.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
