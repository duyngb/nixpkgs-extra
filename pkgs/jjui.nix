{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.9.9";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-kBhEX6k/1vVhSqKeUcIQp6sOpKDnJfgUNKOTzbjG/VI=";
  };
  vendorHash = "sha256-jte0g+aUiGNARLi8DyfsX6wYYJnodHnILzmid6KvMiA=";

  doCheck = false;
})
