{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
}:

stdenv.mkDerivation (rec {
  pname = "agentsview-bin";
  version = "0.44.0";

  src = fetchurl {
    url = "https://github.com/kenn-io/agentsview/releases/download/v${version}/agentsview_${version}_linux_amd64.tar.gz";
    sha256 = "sha256-A36npG1S4GsgNjtKp81/KOMvMdghWAPW6aDJa6xYGOM=";
  };

  dontUnpack = true; # archive has no top-level dir
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontAutoPatchelf = true; # call manually

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
    mkdir -p $out/bin
    tar -xf $src -C $out/bin
    runHook postInstall
  '';

  postInstall = ''
    autoPatchelf -- $out/bin/agentsview
    installShellCompletion --cmd agentsview \
      --bash <($out/bin/agentsview completion bash) \
      --fish <($out/bin/agentsview completion fish) \
      --zsh  <($out/bin/agentsview completion zsh)
  '';

  meta = {
    homepage = "https://agentsview.io";
    license = lib.licenses.mit;
    mainProgram = "agentsview";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
