{
  lib,
  fetchFromGitHub,
  rustPlatform,
  onnxruntime,
  openssl,
  pkg-config,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage (f: {
  pname = "codanna";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "bartolli";
    repo = "codanna";
    tag = "v${f.version}";
    hash = "sha256-/lVsZm5h6hhPD4zMvnFxHEazsmOh+z5QbIEbNSZkgdU=";
  };

  cargoPatches = [ ./cargo-native-tls.patch ];
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  cargoBuildFlags = [
    "-p"
    "codanna"
  ];

  postPatch = ''
    rm -f Cargo.lock
    ln -s ${./Cargo.lock} Cargo.lock

    patch -p1 -d "$NIX_BUILD_TOP/$(stripHash $cargoDeps)/hf-hub-0.5.0" \
      < ${./hf-hub-native-tls.patch}
  '';

  buildInputs = [
    onnxruntime
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  # fastembed uses $HF_HOME as the cache root as-is (no "hub/"), and an empty
  # value resolves to the current directory, so fall back to the default
  # models directory instead.
  postFixup = ''
    wrapProgram $out/bin/codanna --unset HF_HOME
  '';

  ORT_SKIP_DOWNLOAD = "1";
  ORT_PREFER_DYNAMIC_LINK = "1";

  doCheck = false;

  meta = {
    license = lib.licenses.asl20;
    mainProgram = "codanna";
  };
})
