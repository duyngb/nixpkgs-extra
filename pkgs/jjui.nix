{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.3";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-8ckAZb6wNCkocQl2v0VCIii64W5B7VG8LFlnwhQIAT4=";
  };
  vendorHash = "sha256-AJlJ9iHkkWNS8a4oGt8AG89StjMH9UH3WuOcZwa3VS8=";

  doCheck = false;
})
