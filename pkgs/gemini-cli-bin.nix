{
  lib,
  stable,
  fetchurl,
}:

stable.gemini-cli-bin.overrideAttrs (final: {
  version = "0.23.0";
  src = fetchurl {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${final.version}/gemini.js";
    hash = "sha256-TKuI7UC9ofUzRZFqdjY2LEiagjdE2IC471iXkhUCAyw=";
  };
})
