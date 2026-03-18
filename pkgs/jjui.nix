{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.2";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-VTaOd5LSBxo6EhTyjoyAqX+wTEcm88qIgUCcd+TRYY4=";
  };
  vendorHash = "sha256-GDYgZI6X7UwnyKXOJVmqXXtm4ulA10uuX5MeqKVTheA=";

  doCheck = false;
})
