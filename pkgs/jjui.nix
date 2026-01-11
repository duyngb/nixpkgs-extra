{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: {
  version = "0.9.9";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YEEcSaIm21IUp7EFdYvDG2h55YIqzghYdGxdXmZnp9I=";
  };
  vendorHash = "sha256-2TlJJY/eM6yYFOdq8CcH9l2lFHJmFrihuGwLS7jMwJ0=";

  doCheck = false;
})
