{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  stdenv,

  gawk,
  gnutar,
  pv,
  rsync,
  util-linux, # mount, flock
  zstd,
}:

stdenv.mkDerivation (final: {
  pname = "anything-sync-daemon";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "anything-sync-daemon";
    tag = "v${final.version}";
    hash = "sha256-6nfaAMH5YgK6gimuZ8j1zWLTDOi11KIwW7Bf0Iwh7+I=";
  };

  buildInputs = [
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    make common/anything-sync-daemon
    runHook postBuild
  '';

  deps = [
    gawk
    gnutar
    pv
    rsync
    util-linux
    zstd
  ];

  depPaths = lib.makeBinPath final.deps;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 common/anything-sync-daemon $out/bin/anything-sync-daemon
    wrapProgram $out/bin/anything-sync-daemon --inherit-argv0 --prefix PATH : $depPaths
    ln -s anything-sync-daemon $out/bin/asd

    mkdir -p $out/share/man/man1
    install -m644 doc/asd.1 $out/share/man/man1/asd.1

    mkdir -p $out/share/zsh/site-functions
    install -m644 common/zsh-completion $out/share/zsh/site-functions/_asd

    mkdir -p $out/share/bash-completion/completions
    install -m644 common/bash-completion $out/share/bash-completion/completions/asd

    runHook postInstall
  '';

  meta = {
    description = "Symlinks and syncs user specified dirs to RAM";
    homepage = "https://github.com/graysky2/anything-sync-daemon";
    license = lib.licenses.mit;
    mainProgram = "asd";
    platforms = lib.platforms.linux;
  };

  doCheck = false;
  doInstallCheck = false;
})
