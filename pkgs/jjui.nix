{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.6";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-kz1GDk+M98yWVu69nTRVxjC/Kk9qbGFfXXJ5ZwDLEiU=";
  };
  vendorHash = "sha256-I39Tcb28voPSuZhYkEPdvhsViZD7QZZtZjDtRKkZ5LE=";

  doCheck = false;
})
