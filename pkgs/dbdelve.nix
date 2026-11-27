{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,

  cmake,
  fontconfig,
  libGL,
  libxcb,
  libxkbcommon,
  pkg-config,
  psqlodbc,
  unixodbc,
  vulkan-loader,
  wayland,
}:

let
  runtimeDeps = lib.makeLibraryPath [
    libxkbcommon
    psqlodbc
    vulkan-loader
    wayland
  ];
in

rustPlatform.buildRustPackage (f: {
  pname = "dbdelve";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ShayanAbbas1";
    repo = "dbdelve";
    tag = "v${f.version}";
    hash = "sha256-P/qi11q75R1p9Jv8/oLOiJGpGoJjSQ9xfSGSqJeb6X4=";
  };

  cargoHash = "sha256-vetIWgnB8AY/bZhGqgSyI70z0TaMlxH3dFQ93pVCVew=";
  cargoBuildFlags = [
    "-p"
    "dbdelve"
    "-p"
    "dbdelve-plugin-odbc"
  ];

  buildInputs = [
    fontconfig
    libxcb
    libxkbcommon
    psqlodbc
    unixodbc
    wayland
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  postInstall = ''
    plugin=$out/bin/plugins/odbc
    install -Dm644 plugins/odbc/dbdelve-plugin.toml $plugin/dbdelve-plugin.toml
    install -Dm644 $out/bin/dbdelve-odbc $plugin/bin/dbdelve-odbc
    rm $out/bin/dbdelve-odbc
    install -Dm644 assets/linux/dbdelve.desktop $out/share/applications/dbdelve.desktop
  '';

  postFixup = ''
    wrapProgram $out/bin/dbdelve \
      --prefix LD_LIBRARY_PATH : ${runtimeDeps}
  '';

  doCheck = false;

  meta = {
    license = lib.licenses.gpl3;
    mainProgram = "dbdelve";
  };
})
