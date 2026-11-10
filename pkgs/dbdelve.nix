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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ShayanAbbas1";
    repo = "dbdelve";
    tag = "v${f.version}";
    hash = "sha256-/NaXkfgYP+HcBeKqwm+3eW2Z0u9q0laFx5Auw56W3Gk=";
  };

  cargoHash = "sha256-Tz7uCe4e54TZxPsV27iaoVxA6Z0sddTDDQyQkBasjqE=";
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
