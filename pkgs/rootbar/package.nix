{
  lib,
  stdenv,
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

  # https://hg.sr.ht/~scoopta/rootbar @ 36333af9fd8d
  src = fetchTarball {
    url = "https://hg.sr.ht/~scoopta/rootbar/archive/36333af9fd8d7062158b302eb84b6296f538e306.tar.gz";
    sha256 = "sha256:0gfxr92xpfivg85l5v3lhp6s3f74bk6qg4rn9f5rflh42g32gvnb";
  };

  patches = [
    ./0001-Update-MPRIS-plugin.patch
    ./0002-Allow-bar-s-output-to-be-omitted.patch
    ./0003-fix-Crash-on-bad-MPRIS-message.patch
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
