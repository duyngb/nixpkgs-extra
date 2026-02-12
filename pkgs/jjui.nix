{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.9.11";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-WkUMDIzVW6n5Zp1r7rp1GgkcgswatmgNYdSpkmz5VWs=";
  };
  vendorHash = "sha256-nXUaqkCz3QERqevwGk94sRrrPgJoJOPWXYc7iBOMAdY=";

  doCheck = false;
})
