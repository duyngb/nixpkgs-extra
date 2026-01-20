{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.9.10";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-Hsuyf5VcSZcNi2gmubXS47uRarL17oPEtorisY75bbM=";
  };
  vendorHash = "sha256-jte0g+aUiGNARLi8DyfsX6wYYJnodHnILzmid6KvMiA=";

  doCheck = false;
})
