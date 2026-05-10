{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.5";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-3cr6aSJoIAv9Ine2ePHCC6xBaS1G4i23yQh8I5mq47g=";
  };
  vendorHash = "sha256-iUWeQIYwOkXhRFsQc5zBjFFG5m412ysR5LsZsHET1ak=";

  doCheck = false;
})
