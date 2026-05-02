{
  fetchFromGitHub,
  fishPlugins,
  lib,
}:

fishPlugins.z.overrideAttrs {
  version = "0-unstable-2026-04-16";
  src = fetchFromGitHub {
    owner = "jethrokuan";
    repo = "z";
    rev = "26a50962bc68f5cb60fc488ee008b3d4d5be75f4";
    sha256 = "sha256-4+58sbZf852HImPqWmlJUtuZI0464nx+SyvZbrtsG+E=";
  };
}
