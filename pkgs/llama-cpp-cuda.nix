{
  callPackage,
  cudaPackages_12_8,
}:

callPackage ./llama-cpp.nix {
  cudaSupport = true;
  cudaPackages = cudaPackages_12_8;
}
