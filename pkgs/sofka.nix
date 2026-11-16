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
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "nklmilojevic";
    repo = "sofka";
    tag = "v${f.version}";
    hash = "sha256-5n9/eZsZa7EIwm8bZvG3cAmXusgLmvPQREEcWSqrIts=";
  };
  cargoHash = "sha256-8vSD8EQmzMZM4zuKyPB9gjVHDncHkVycp7sU7/7TUNk=";

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
