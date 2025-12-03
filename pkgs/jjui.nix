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

  version = "0.9.7";
  srcHash = "sha256-WkJofvalxjcehlVZiPB51jw7exQ2rU8CiRq3gxMKzEQ=";
  vendorHash = "sha256-dSODeMvlPWrOS97sw1qbf3vrmv8Bs+Z3rmN0ZRV/KjU=";
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
