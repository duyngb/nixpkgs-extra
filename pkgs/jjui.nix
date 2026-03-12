{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.1";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-o648hMSoEa21GqK4VGSa4hf5KP5FVu80Ea5NB2QwII0=";
  };
  vendorHash = "sha256-GDYgZI6X7UwnyKXOJVmqXXtm4ulA10uuX5MeqKVTheA=";

  doCheck = false;
})
