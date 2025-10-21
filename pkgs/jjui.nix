{
  inputs,
  system,
  fetchFromGitHub,

  versionCheckHook,
}:

let
  super = inputs.nixpkgs.legacyPackages.${system};
  basepkg = super.jjui;

  version = "0.9.5";
  srcHash = "sha256-QaAjxpn7VHUdL8PFQcDUsa7xA/7bMtGaGl1aTpKOs2M=";
  vendorHash = "sha256-YBRHpHBb3uzgXhwxVu3493CtPyG9Vzm8IPc1VW6/CKU=";
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
