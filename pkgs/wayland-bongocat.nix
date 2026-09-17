# Port of wayland-bongocat to nixos-25.05
{
  lib,
  stdenv,
  fetchFromGitHub,

  # For package building
  bash,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayland-bongocat";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "saatvik333";
    repo = "wayland-bongocat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JP7Rcwf+3n6IouuGw3VwhUGLpmEo6ou04nLVWZW5TLo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
  ];

  preBuild = ''
    export WAYLAND_PROTOCOLS_DIR="${wayland-protocols}/share/wayland-protocols"
  '';

  makeFlags = [ "release" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 build/bongocat $out/bin/bongocat
    install -Dm755 scripts/find_input_devices.sh $out/bin/bongocat-find-devices

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "Delightful Wayland overlay that displays an animated bongo cat reacting to keyboard input";
    homepage = "https://github.com/saatvik333/wayland-bongocat";
    license = licenses.mit;
    mainProgram = "bongocat";
    platforms = platforms.linux;
  };
})
