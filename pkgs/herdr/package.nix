{
  callPackage,
  fetchFromGitHub,
  gitMinimal,
  lib,
  pkg-config,
  runCommand,
  rustPlatform,
  zig_0_16,
  zstd,
}:

rustPlatform.buildRustPackage (f: {
  pname = "herdr";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "herdrdev";
    repo = "herdr";
    tag = "v${f.version}";
    hash = "sha256-N7e7oCKxeCoxek6UT8Lweq16rSsQQi34QMb7C2iNpm8=";
  };

  cargoHash = "sha256-a6DgQodo+qa5yg/d+yMfsM9EUv2LQRFrqZgmwgVxggE=";

  zigDeps = callPackage ("${f.src}/vendor/libghostty-vt/build.zig.zon.nix") {
    name = "herdr-libghostty-vt-zig-cache";
    inherit zstd;
    linkFarm =
      name: entries:
      runCommand name { } ''
        mkdir -p $out
        ${lib.concatMapStringsSep "\n" (entry: ''
          cp -rL ${entry.path} $out/${entry.name}
        '') entries}
      '';
  };

  nativeBuildInputs = [
    gitMinimal
    pkg-config
  ];

  env = {
    LIBGHOSTTY_VT_OPTIMIZE = "ReleaseFast";
    LIBGHOSTTY_VT_SIMD = "true";
    LIBGHOSTTY_VT_ZIG_SYSTEM_DIR = f.zigDeps;
    ZIG = lib.getExe zig_0_16;
  };

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-global-cache"
    export ZIG_LOCAL_CACHE_DIR="$TMPDIR/zig-local-cache"
  '';

  doCheck = false; # TODO: should we run unstream tests?

  __structuredAttrs = true;

  meta = {
    homepage = "https://herdr.dev";
    license = lib.licenses.asl20;
    mainProgram = "herdr";
    platforms = lib.platforms.linux;
  };
})
