{ inputs, ... }:

let
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final;
      directory = ./pkgs;
    });
in
{
  default =
    final: prev:

    {
      inherit inputs;
      stable = prev;
    }

    // (additions final prev);
}
