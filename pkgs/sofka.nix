{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  cmake,
  nix-update-script,
}:

rustPlatform.buildRustPackage (f: {
  pname = "sofka";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "nklmilojevic";
    repo = "sofka";
    tag = "v${f.version}";
    hash = "sha256-y9i0oWMztcmDJ+QOqfedWYftqbK8bY+vSUnuopgt2zg=";
  };
  cargoHash = "sha256-Tz+wElisOiv599c91NcmoOwJy2scvQMYI6cvlxc1rMU=";

  buildInputs = [
    cmake
    installShellFiles
  ];
  postInstall = ''
    installShellCompletion --cmd sofka \
      --bash <($out/bin/sofka completion bash) \
      --fish <($out/bin/sofka completion fish) \
      --zsh  <($out/bin/sofka completion zsh )
  '';

  doCheck = false; # can't test without network

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://sofka.rs";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    mainProgram = "sofka";
  };
})
