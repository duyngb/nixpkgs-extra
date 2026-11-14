{
  lib,
  fetchurl,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  python3,
  rustfmt,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "windowtolayer";
  version = "0.4.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/mstoeckl/windowtolayer/-/archive/v${finalAttrs.version}/windowtolayer-v${finalAttrs.version}.tar.gz";
    hash = "sha256-z5b0MtdG92YNK9gZ2TRIo5NhRo+KvGhv/NouW0k6AqU=";
  };

  cargoHash = "sha256-Y+8v7Q9vs3f5MttFED9Ym6+WS1W0RcPTpDMKcESNRtY=";

  nativeBuildInputs = [
    python3
    rustfmt
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    license = lib.licenses.gpl3;
    mainProgram = "windowtolayer";
  };
})
