{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  versionCheckHook,
}:

let
  encore-go = fetchurl {
    name = "encore-go-x86_64-linux-1.25.4.tar.gz";
    url = "https://github.com/encoredev/go/releases/download/encore-go1.25.4/linux_x86-64.tar.gz";
    hash = "sha256-Q83ZoLqwUHuh9BlPuZ0/SzO8w4RdllZddM+uAVIqTRs=";
  };

  # The encore-go above is lagging behind a bit. Until we
  # figure out the right way to build golang from source
  # and patch, let's borrow the stuff in CLI distribution.
  # The URLs and hashes are from encore-flake
  encore-cli = fetchurl {
    url = "https://d2f391esomvqpi.cloudfront.net/encore-1.58.4-linux_amd64.tar.gz";
    sha256 = "69c2b5959f52adc9c249edba0562987da2d06f1f59926be52a410ceddd5734b6";
  };
in

buildGoModule (final: {
  pname = "encoredev";
  version = "${final.baseVersion}+nix0";
  baseVersion = "1.58.4";

  src = fetchFromGitHub {
    owner = "encoredev";
    repo = "encore";
    tag = "v${final.baseVersion}";
    hash = "sha256-01Xj075VeQmGLEw+Sbq5LHbQmD0t1zSHjJdi1fBe4fI=";
  };

  vendorHash = "sha256-XrfujphhmYH6UPplNmCgnYpvmZgLHWtET9HlFuHz7oE=";

  ldflags = [
    "-X encr.dev/internal/version.Version=v${final.version}"
  ];

  patches = [
    ./0001-correct-volume-mount.patch
    ./0002-nsqd-tmpdir.patch
  ];

  subPackages = [
    "cli/cmd/encore"
    "cli/cmd/git-remote-encore"
  ];

  postInstall = ''
    tar -xf $encore_cli -C $out ./encore-go
    cp -r runtimes $out/runtimes
  '';

  env = {
    encore_cli = encore-cli;
    CGO_ENABLED = 1;
  };

  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  dontStrip = true;

  # This is for stuff inside encore-go. These are mentioned
  # by go internal tests. We don't really need to redo go's
  # tests here, so we can skip these for now.
  autoPatchelfIgnoreMissingDeps = [
    "libtiff.so.6"
    "libstdc++.so.6"
  ];

  passthru = {
    inherit
      encore-go
      encore-cli
      ;
  };

  meta = {
    description = "encore cli";
    homepage = "https://encore.dev";
    license = lib.licenses.mpl20;
    mainProgram = "encore";
    platforms = [
      # TODO: actually, there are more supported platforms
      "x86_64-linux"
    ];
  };
})
