{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  stdenv,
}:
buildGo127Module (final: {
  pname = "jjui";
  version = "0.10.11";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${final.version}";
    hash = "sha256-dHw1imeAenwa1/+bgcpS9LUs59UlJDS5LAujoIabVH0=";
  };

  vendorHash = "sha256-gHfE924uFXtSyRbt2uxK+1/lU04aC1wCgoHWJ3gE7xo=";

  subPackages = [
    "cmd/jjui"
  ];

  dontStrip = true;
  ldflags = [
    "-s"
    "-X main.Version=${final.version}"
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-skip=TestServerAskpass"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for Jujutsu VCS";
    homepage = "https://github.com/idursun/jjui";
    changelog = "https://github.com/idursun/jjui/releases/tag/v${final.version}";
    license = lib.licenses.mit;
    mainProgram = "jjui";
  };
})
