{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.9.12";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-CBNMoVALCLWQ9bsrQilnx8djLufLNt8p9iK+HnpUPgc=";
  };
  vendorHash = "sha256-nXUaqkCz3QERqevwGk94sRrrPgJoJOPWXYc7iBOMAdY=";

  doCheck = false;
})
