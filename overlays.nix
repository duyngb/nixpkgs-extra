{ inputs, ... }:

let
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final;
      directory = ./pkgs;
    });

  devpack-rust =
    final: prev:
    let
      pkgs' = import inputs.nixpkgs {
        inherit (prev) system;
        overlays = [ inputs.rust-overlay.overlays.default ];
      };
    in
    {
      inherit (pkgs') makeRustPlatform rust-bin;
      rustPlatform = pkgs'.makeRustPlatform {
        cargo = pkgs'.rust-bin.stable.latest.default;
        rustc = pkgs'.rust-bin.stable.latest.default;
      };
    };

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
