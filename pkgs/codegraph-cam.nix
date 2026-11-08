{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  onnxruntime,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (f: {
  pname = "codegraph-cam";
  version = "0.0.0-20261006";

  src = fetchFromGitHub {
    owner = "Jakedismo";
    repo = "codegraph-code-agent-memory-rust";
    rev = "4e46ba6232bce633cf59146decfec04bb564666f";
    hash = "sha256-iVUJj27XZQqevenetO8lpQ3KBW0gUY7cKaJN5JXKDcE=";
  };

  cargoHash = "sha256-x2MrG2GGwbs4v0z0va9tZjTJhddQMRkqbyvIGpAF5+U=";
  cargoBuildFlags = [
    "-p"
    "codegraph-mcp-server"
    "--bin"
    "codegraph"
    "--features"
    "memory,server-http,ai-enhanced,embeddings-openai,embeddings-local"
  ];

  buildInputs = [
    onnxruntime
    openssl
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  ORT_SKIP_DOWNLOAD = "1";
  ORT_PREFER_DYNAMIC_LINK = "1";

  doCheck = false;

  meta = {
    license = lib.licenses.asl20;
    mainProgram = "codegraph";
  };
})
