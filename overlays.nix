{ inputs, ... }:

let
  additions =
    final: prev:
    let
      final' = final // {
        rustPlatform = final.makeRustPlatform {
          cargo = final.rust-bin.stable.latest.default;
          rustc = final.rust-bin.stable.latest.default;
        };
      };
    in
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final';
      directory = ./pkgs;
    });

  devpack-rust = inputs.rust-overlay.overlays.default;
in
{
  default =
    final: prev:

    {
      inherit inputs;
      stable = prev;
    }

    // (additions final prev)

    // (devpack-rust final prev)

  ;
}
