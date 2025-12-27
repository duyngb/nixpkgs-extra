{
  lib,
  fetchurl,
  stdenv,
}:

let
  throwNoSystem = throw "unsupported system: ${stdenv.hostPlatform.systmm}";

  goArch = {
    x86_64-linux = "amd64";
  };

  arch = goArch.${stdenv.hostPlatform.system} or throwNoSystem;

  pname = "jaeger-bin";
  version = "2.13.0";
  tag = "v1.76.0";

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/jaegertracing/jaeger/releases/download/${tag}/jaeger-${version}-linux-${arch}.tar.gz";
    hash = "sha256-fGKLXd3ntUObK2SA+z8xkxCyFTWSMRFR5MLi1F9t7RM=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    mv -t "$out/bin" jaeger example-hotrod
    runHook postInstall
  '';

  meta = {
    description = "Trace collector";
    homepage = "https://www.jaegertracing.io/";
    license = lib.licenses.asl20;
    mainProgram = "jaeger";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
