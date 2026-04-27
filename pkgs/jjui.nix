{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.4";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-20NWoojFBwHs33NFNeZbk1kiZ418kYD42XTUOHuQtv8=";
  };
  vendorHash = "sha256-AJlJ9iHkkWNS8a4oGt8AG89StjMH9UH3WuOcZwa3VS8=";

  doCheck = false;
})
