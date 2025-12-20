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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uR2E7I+aX7f+efwMTqWBRL3JYvlqnoHPCXZ61MDq+uQ=";
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
  vendorHash = "sha256-ruU6t7fZrB+sap9VKPTO/qhgEORQ3R8pddW04j4vcik=";
  env.GOWORK = "off";
  # ---------------------------------------------------------------------------
})
