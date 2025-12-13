{
  fetchFromGitHub,
  stable,
}:

stable.jjui.overrideAttrs (finalAttrs: {
  version = "0.9.8";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sLOQa9IoRcYEXcShiE/vdjJknQcDwefVwHii63MPXpw=";
  };
  vendorHash = "sha256-SMeS1FHc8UdXaxF9A8eYFkWQIM0hgWfBpuX+DsBglcw=";

  doCheck = false;
})
