{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.8";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-ZbmCPCTsSbphLUy+lrTt4/6DVq70edKGI59U0HDbawE=";
  };
  vendorHash = "sha256-thGlfZ0SwHpynYydxu6Sg8OUe5kr7jiPKvl6BXS5BWA=";

  doCheck = false;
})
