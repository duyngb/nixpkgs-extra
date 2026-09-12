let
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final;
      directory = ./pkgs;
    });
in
{
  default = final: prev: { stable = prev; } // (additions final prev);
}
