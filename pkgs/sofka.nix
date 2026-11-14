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
  version = "0.35.1";

  src = fetchFromGitHub {
    owner = "nklmilojevic";
    repo = "sofka";
    tag = "v${f.version}";
    hash = "sha256-o9F54joKQ3ypZDs1Lw/AgGN42+fFJOJ+BE4Pou3KkXY=";
  };
  cargoHash = "sha256-l+nQJFB/ZMMO3AI/YoHvk2Lz4D1Q66o6SQJb/A2vdjs=";

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
