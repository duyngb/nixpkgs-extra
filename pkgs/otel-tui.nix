{
  lib,
  buildGo125Module,
  fetchFromGitHub,
}:

# using go 1.25 builder, as nixpkgs stable is stuck at 1.24.6, needs 1.24.7
buildGo125Module (finalAttrs: {
  meta = {
    description = "A terminal OpenTelemetry viewer inspired by otel-desktop-viewer";
    homepage = "https://github.com/ymtdzzz/otel-tui";
    license = lib.licenses.asl20;
  };

  pname = "otel-tui";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x23M69Migk822OIsWnbK2LlfIeBs4//qwJMCRJ0HY+g=";
  };

  ldFlags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

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
  vendorHash = "sha256-GSPCa4rVSTqQfalcWntCDxYhgtNw0S80wFB6AnbbrQQ=";
  env.GOWORK = "off";
  # ---------------------------------------------------------------------------
})
