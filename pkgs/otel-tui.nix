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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RYGSMdJQ2qj6930PX/UWFrN2orQzRpufHiKDv6lmAw4=";
  };

  vendorHash = "sha256-MRDbVmEjli2QgnxnCryjhYYQs4xNyUMC0ql9N36PkYo=";

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
