# (c) nixos
{
  lib,
  autoAddDriverRunpath,
  cmake,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,

  config,

  cudaSupport ? false,
  blasSupport ? builtins.all (x: !x) [
    cudaSupport
    vulkanSupport
  ],

  vulkanSupport ? false,
  rpcSupport ? false,

  cpuArchDynamicDispatch ? false,

  cudaPackages_12_8,
  cudaPackages ? cudaPackages_12_8,

  blas,

  pkg-config,
  openssl,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  spirv-headers,
  ninja,

  buildNpmPackage,
  fetchNpmDeps,
}:

let
  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  inherit (lib)
    cmakeBool
    cmakeFeature
    optionals
    optionalString
    ;

  cudaBuildInputs = with cudaPackages; [
    cuda_cccl # <nv/target>

    # A temporary hack for reducing the closure size, remove once cudaPackages
    # have stopped using lndir: https://github.com/NixOS/nixpkgs/issues/271792
    cuda_cudart
    libcublas
  ];

  vulkanBuildInputs = [
    shaderc
    vulkan-headers
    vulkan-loader
    spirv-headers
  ];

  mkvar = name: hasSupport: { inherit name hasSupport; };

  pnameSuffix =
    lib.pipe
      [
        (mkvar "cuda" cudaSupport)
        (mkvar "vulkan" vulkanSupport)
      ]
      [
        (builtins.filter (v: v.hasSupport))
        (builtins.map (v: v.name))
        (builtins.concatStringsSep "-")
      ];

  pname = "llama-cpp" + (if pnameSuffix != "" then "-" + pnameSuffix else "");
  version = "9608";
  srcHash = "sha256-nNQzEfSqVwusixHdiZCyAOtrQTQ7aAdV+S9qZywWWx0=";
  npmDepsHash = "sha256-pjdbI6NcZRlJVd62xhgbLhWrwFYwgsIwjORqvo1+VD8=";

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "b${version}";
    hash = srcHash;
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  uipkg = buildNpmPackage (final: {
    inherit src version;
    pname = "llama-cpp-ui";
    npmDepsHash = npmDepsHash;
    npmRoot = "tools/ui";
    npmDeps = fetchNpmDeps {
      name = "llama-cpp-${final.version}-npm-deps";
      inherit src;
      preBuild = ''
        pushd ${final.npmRoot}
      '';
      hash = final.npmDepsHash;
    };
    preBuild = ''
      pushd ${final.npmRoot}
    '';
    dontNpmInstall = true;
    installPhase = ''
      mkdir -p $out
      cp -r dist/* $out
    '';
  });

in
effectiveStdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  outputs = [
    "out"
    "dev"
  ];

  patches = [ ];

  nativeBuildInputs = [
    cmake
    installShellFiles
    ninja
    pkg-config
  ]
  ++ optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs =
    optionals cudaSupport cudaBuildInputs
    ++ optionals blasSupport [ blas ]
    ++ optionals vulkanSupport vulkanBuildInputs
    ++ [ openssl ];

  preConfigure = ''
    prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
    ln -s ${uipkg} tools/ui/dist
  '';

  CFLAGS = "-march=skylake -mtune=skylake -ffast-math -fno-finite-math-only";
  CXXFLAGS = finalAttrs.CFLAGS;

  cmakeFlags = [
    # -march=native is non-deterministic; override with platform-specific flags if needed
    (cmakeBool "GGML_NATIVE" false)
    (cmakeBool "GGML_CCACHE" false)
    (cmakeBool "LLAMA_BUILD_EXAMPLES" false)
    (cmakeBool "LLAMA_BUILD_SERVER" true)
    (cmakeBool "LLAMA_BUILD_TESTS" (finalAttrs.finalPackage.doCheck or false))
    (cmakeBool "LLAMA_OPENSSL" true)
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "GGML_BLAS" blasSupport)
    (cmakeBool "GGML_CUDA" cudaSupport)
    (cmakeBool "GGML_RPC" rpcSupport)
    (cmakeBool "GGML_VULKAN" vulkanSupport)
    (cmakeFeature "LLAMA_BUILD_NUMBER" finalAttrs.version)
  ]
  ++ optionals cpuArchDynamicDispatch [
    # Build all CPU backend variants for runtime dynamic dispatch.
    # This avoids illegal instructions on older CPUs and gives optimal performance
    # on newer ones without needing separate builds.
    # Enabling AVX2 can make CPU inference 13x faster compared to NixOS's x86_64 defaults.
    # Note it is not a bug that the CPU variant .so files are placed in `bin/`
    # (as opposed to `lib/`) alongside the executables by upstream's `CMakeLists.txt` design:
    # * https://github.com/ggml-org/llama.cpp/blob/b46812de78f8fbcb6cf0154947e8633ebc78d9ac/ggml/src/CMakeLists.txt#L249-L252
    # * https://github.com/ggml-org/llama.cpp/blob/b46812de78f8fbcb6cf0154947e8633ebc78d9ac/ggml/src/ggml-backend-reg.cpp#L480-L486
    (cmakeBool "GGML_CPU_ALL_VARIANTS" true)
    (cmakeBool "GGML_BACKEND_DL" true)
  ]
  ++ optionals cudaSupport [
    # (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
    (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" "61-real")
    (cmakeFeature "CMAKE_CUDA_FLAGS" "-Wno-deprecated-gpu-targets")
  ]
  ++ optionals rpcSupport [
    # This is done so we can move rpc-server out of bin because llama.cpp doesn't
    # install rpc-server in their install target.
    (cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  # upstream plans on adding targets at the cmakelevel, remove those
  # additional steps after that
  postInstall = ''
    # Match previous binary name for this package
    ln -sf $out/bin/llama-cli $out/bin/llama

    mkdir -p $out/include
    cp $src/include/llama.h $out/include/

  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd llama-server --bash <($out/bin/llama-server --completion-bash)
  ''
  + optionalString rpcSupport "cp bin/rpc-server $out/bin/llama-rpc-server";

  # the tests are failing as of 2025-08
  doCheck = false;

  passthru = {
    inherit uipkg;

    updateScript = nix-update-script {
      attrPath = "llama-cpp";
      extraArgs = [
        "--version-regex"
        "b(.*)"
      ];
    };
  };

  meta = {
    description = "Inference of Meta's LLaMA model (and others) in pure C/C++";
    homepage = "https://github.com/ggml-org/llama.cpp";
    license = lib.licenses.mit;
    mainProgram = "llama-cli";
    platforms = lib.platforms.unix;
    badPlatforms = optionals (cudaSupport) lib.platforms.darwin;
  };
})
