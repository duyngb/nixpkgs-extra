{
  lib,
  stable,
  fetchurl,
}:

stable.gemini-cli-bin.overrideAttrs (final: rec {
  version = "0.23.0";
  src = fetchurl {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${version}/gemini.js";
    hash = "sha256-9ZWdPHOCVpxZLM2c5tNQDFDs8RRlj5duUBAVRYRjg+E=";
  };
})
