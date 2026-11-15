{
  lib,
  stdenv,
  makeBinaryWrapper,
  tty7-unwrapped,

  libxkbcommon,
  wayland,
  vulkan-loader,
}:

let
  runtimeDeps = lib.makeLibraryPath [
    libxkbcommon
    wayland
    vulkan-loader
  ];
in

stdenv.mkDerivation {
  inherit (tty7-unwrapped) pname version meta;

  __structuredAttrs = true;
  strictDeps = true;

  src = tty7-unwrapped;
  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildPhase = ''
    cp -rs --no-preserve=mode $src $out
    wrapProgram $out/bin/tty7-app \
      --prefix LD_LIBRARY_PATH : ${runtimeDeps} \
      --suffix LD_LIBRARY_PATH : /run/opengl-driver \
      --prefix PATH : $out/bin
    for app in tty7 tty7-server; do
      wrapProgram $out/bin/$app --prefix PATH : $out/bin
    done
    rm $out/share/applications/tty7.desktop
    substituteAll ${../tty7-unwrapped/tty7.desktop} \
      $out/share/applications/tty7.desktop
  '';
}
