{
  inputs,
  stdenv,
  fetchFromGitHub,

  versionCheckHook,
}:

let
  system = stdenv.hostPlatform.system;
  super = inputs.nixpkgs.legacyPackages.${system};
  basepkg = super.jjui;

  version = "0.9.6";
  srcHash = "sha256-sLOQa9IoRcYEXcShiE/vdjJknQcDwefVwHii63MPXpw=";
  vendorHash = "sha256-SMeS1FHc8UdXaxF9A8eYFkWQIM0hgWfBpuX+DsBglcw=";
in

basepkg.overrideAttrs {
  inherit version vendorHash;

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "${srcHash}";
  };

  # backport from nixpkgs-unstable

  ldflags = [
    "-X main.Version=${version}"
    "-buildid="
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
}
