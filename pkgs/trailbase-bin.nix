{
  lib,
  fetchzip,
  stdenv,
}:

stdenv.mkDerivation (final: {
  pname = "trailbase-bin";
  version = "0.26.3";

  src = fetchzip {
    url = "https://github.com/trailbaseio/trailbase/releases/download/v${final.version}/trailbase_v${final.version}_x86_64_linux.zip";
    hash = "sha256-7pm6jmwj/SMCoukAFl9VwoXRvbwm74Nj1eAgRI9ujHE=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/bin
    install trail $out/bin
  '';

  meta = {
    description = "An open, sub-millisecond, single-executable Firebase alternative with type-safe APIs, built-in WebAssembly runtime, realtime subscriptions, auth, and admin UI built on Rust, SQLite & Wasmtime.";
    license = lib.licenses.osl3;
    mainProgram = "trail";
  };
})


