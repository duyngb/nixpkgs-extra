{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (f: {
  pname = "zmx-bin";
  version = "1.0.1";
  __structuredAttrs = true;

  dontUnpack = true;
  src = fetchurl {
    url = "https://github.com/neurosnap/zmx/releases/download/v${f.version}/zmx-${f.version}-linux-x86_64.tar.gz";
    sha256 = "sha256-RzGf+fMwtl4U3HmVF2mdE8XzIoINCKvsq5n4sYvqqi0=";
  };

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    tar -xf $src -C $out/bin
    chmod 755 $out/bin/zmx
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zmx \
      --bash <($out/bin/zmx completions bash) \
      --fish <($out/bin/zmx completions fish) \
      --zsh  <($out/bin/zmx completions zsh)
  '';

  doCheck = false;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://zmx.sh";
    description = "Session persistence for terminal processes";
    license = lib.licenses.mit;
    mainProgram = "zmx";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.unix;
  };
})
