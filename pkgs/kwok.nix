{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kwok";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kwok";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SXiZiDor/+58JcKSBPHOWijvuCqdFmP2vRKJzLTriw8=";
  };

  vendorHash = "sha256-Y+tQKkuLPA4gGtlhQlG8rrvNB+n0whRKUpaqIf1WxX8=";

  subPackages = [
    "cmd/kwok"
    "cmd/kwokctl"
  ];

  doCheck = false; # need docker

  doInstallCheck = true;

  installCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  buildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh  <($out/bin/${finalAttrs.meta.mainProgram} completion zsh )
  '';

  meta = {
    description = "Simulate massive Kubernetes clusters with low resource usage locally without kubelet";
    homepage = "https://kwok.sigs.k8s.io";
    changelog = "https://github.com/kubernetes-sigs/kwok/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    mainProgram = "kwokctl";
  };
})
