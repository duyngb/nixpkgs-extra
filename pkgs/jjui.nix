{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.9";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-D/ZBH9bsiWO26+xxixD8RKgnoA3x74YdYAIoRznsBTQ=";
  };
  vendorHash = "sha256-BldmFVYpRPdnyeswPKGspH4oZ2mjvFS5VbTu3DN5bJg=";

  doCheck = false;
})
