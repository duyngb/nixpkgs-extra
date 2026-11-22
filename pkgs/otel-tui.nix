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
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wQItMR7SOyCEt1u3iCbYvb03BhNA0cwSPrdZ4Zg46ZI=";
  };

  vendorHash = "sha256-WMwQlFKxBPPMzD2ay6ikQBO1B3mxYcXOOICwRKepcsQ=";

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
