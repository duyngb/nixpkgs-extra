{
  inputs,
  system,
  fetchFromGitHub,

  versionCheckHook,
}:

let
  super = inputs.nixpkgs.legacyPackages.${system};
  basepkg = super.jjui;

  version = "0.9.3";
  srcHash = "sha256-UkgQ3uxWPwLQiNhcZReFifLPD8h+xmH798ckTtia/+4=";
  vendorHash = "sha256-VfzvGzh/ZYHI5LDuhwOwb4nEOVesBu0kxRF6Q/ISPww=";
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
