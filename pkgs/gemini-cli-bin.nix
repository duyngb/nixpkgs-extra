{
  lib,
  stdenvNoCC,
  fetchurl,
  nodejs_20,
  ripgrep,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: rec {
  pname = "gemini-cli-bin";
  version = "0.33.1";

  src = fetchurl {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${version}/gemini.js";
    hash = "sha256-AWsXfHOfd5HoseqacmfkO+vuJStuG2vLysd0EUyF2f8=";
  };

  dontUnpack = true;
  strictDeps = true;

  nativeBuildInputs = [
    nodejs_20
    ripgrep
  ];

  buildInputs = [
    nodejs_20
    ripgrep
  ];

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/bin/gemini"
    sed -i '/disableautoupdate: {/,/}/ s/default: false/default: true/' "$out/bin/gemini"

    # use `ripgrep` from `nixpkgs`, more dependencies but prevent downloading incompatible binary on NixOS
    # this workaround can be removed once the following upstream issue is resolved:
    # https://github.com/google-gemini/gemini-cli/issues/11438
    substituteInPlace $out/bin/gemini \
      --replace-fail 'const existingPath = await resolveExistingRgPath();' 'const existingPath = "${lib.getExe ripgrep}";'

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "-v";

  passthru.updateScript = nix-update-script {
    # Ignore `preview` and `nightly` tags
    extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
  };

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    mainProgram = "gemini";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    priority = 10;
  };
})
