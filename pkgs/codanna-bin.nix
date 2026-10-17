{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
}:

stdenv.mkDerivation (rec {
  pname = "codanna-bin";
  version = "0.17.1";

  src = fetchurl {
    url = "https://github.com/bartolli/codanna/releases/download/v0.17.1/codanna-${version}-linux-x64.tar.xz";
    sha256 = "sha256-QbQp4cj2OdR0oUpDsjoAVK067ObwhI7zOS4VOnF9Nzk=";
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
    install -Dm755 codanna $out/bin/codanna
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ninjaxtools/slopdex";
    license = lib.licenses.mit;
    mainProgram = "slopdex";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
