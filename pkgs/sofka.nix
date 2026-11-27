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
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "nklmilojevic";
    repo = "sofka";
    tag = "v${f.version}";
    hash = "sha256-N9u/v/pcBToekkuAWj0m/hjj1hqIQu3a+d/9mN9mzOI=";
  };
  cargoHash = "sha256-JTzaEWGQc5LkImjNxGmf9tbw+a3AnQz64nfkU9f5so0=";

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
