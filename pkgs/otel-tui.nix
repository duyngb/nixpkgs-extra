{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  meta = {
    description = "A terminal OpenTelemetry viewer inspired by otel-desktop-viewer";
    homepage = "https://github.com/ymtdzzz/otel-tui";
    license = lib.licenses.asl20;
    mainProgram = "otel-tui";
  };

  pname = "otel-tui";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+OvbBmFGyS5tpFtgn1DDxWp+LD5BAl9ojSIDGokfcRk=";
  };

  vendorHash = "sha256-7/D9FUMiCb/I3WFGiJKNsl4lUvr96+yvZ+MxzDw6Quw=";

  ldFlags = [
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false;
  doInstallCheck = false;
  env.CGO_ENABLED = "0";

  subPackages = [ "." ];

  overrideModAttrs = (
    _: {
      buildPhase = ''
        go work vendor
      '';
    }
  );
})
