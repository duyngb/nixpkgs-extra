{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
}:

stdenv.mkDerivation (rec {
  pname = "slopdex-bin";
  version = "0.46.0";

  src = fetchurl {
    url = "https://github.com/ninjaxtools/slopdex/releases/download/v${version}/slopdex-x86_64-unknown-linux-gnu.tar.xz";
    sha256 = "sha256-Gkf6OUBm31Jl6kelQt/wPAH8gNXYdWLOGsMTvNgJlrk=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 slopdex $out/bin/slopdex
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ninjaxtools/slopdex";
    license = lib.licenses.mit;
    mainProgram = "slopdex";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
