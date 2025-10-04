{ inputs, ... }:

let
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final;
      directory = ./pkgs;
    });

  devpack-rust = inputs.rust-overlay.overlays.default;

  devpack-zig =
    final: prev:
    let
      pkgs' = inputs.zig-overlay.overlays.default final prev;
    in
    {
      zls = inputs.zls-src.packages.${prev.system}.default;
      zig = pkgs'.zigpkgs.default;
    };
in
{
  default =
    final: prev:

    {
      inherit inputs;
    }

    // (additions final prev)

    // (devpack-zig final prev)

    // (devpack-rust final prev)

  ;
}
