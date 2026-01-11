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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V12mnV4CqHg7tM6ypG5NctTSFDu+jz0sC7p1v8Ax47A=";
  };

  ldFlags = [
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false;
  doInstallCheck = false;
  env.CGO_ENABLED = "0";

  # ---------------------------------------------------------------------------
  # BUGGY ZONE: buildGoModule does not handle workspace well
  #   ref: https://github.com/NixOS/nixpkgs/issues/203039
  #   ref: https://github.com/NixOS/nixpkgs/issues/299096
  #
  # Need to set subPackages, or the build will failed with module not found
  # error; found by repo's nix expression.
  #
  subPackages = [ "." ];
  #
  # This vendor hash was obtained with GOWORK=off
  #
  vendorHash = "sha256-zUx47lOT2Rb+EaGHGI7TNH7YUovt00mRtLntjsVtrnQ=";
  env.GOWORK = "off";
  # ---------------------------------------------------------------------------
})
