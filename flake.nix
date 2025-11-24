{
  outputs =
    inputs@{
      self,
      nixpkgs,
      rust-overlay,
      zig-overlay,
      zls-src,
      ...
    }:
    let
      lib = nixpkgs.lib.extend (
        self: super: {
          relativeToRoot = nixpkgs.lib.path.append ./.;
        }
      );

      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    {
      # ----------------
      # NixPkgs Overlays
      # ----------------
      overlays = import ./overlays.nix { inherit inputs; };

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        nixpkgs.lib.packagesFromDirectoryRecursive {
          callPackage = nixpkgs.lib.callPackageWith pkgs;
          directory = ./pkgs;
        }
        // {
          inherit (pkgs) neovide;
        }
      );

      legacyPackages = forAllSystems (system: self.packages.${system});

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    rust-overlay = {
      url = "github:oxalica/rust-overlay/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig-overlay = {
      url = "github:mitchellh/zig-overlay?ref=b5f76ad0830c1e11e2e3c5a39792a663e645d57b";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls-src = {
      url = "github:zigtools/zls/0.15.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig-overlay.follows = "zig-overlay";
    };
  };
}
