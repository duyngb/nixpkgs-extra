{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: rec {
  version = "0.10.7";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-IcJImxowBuQy9MBsz4QesDJM484qSvfQxPx4ykQ0ttA=";
  };
  vendorHash = "sha256-thGlfZ0SwHpynYydxu6Sg8OUe5kr7jiPKvl6BXS5BWA=";

  doCheck = false;
})
