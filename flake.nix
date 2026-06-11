{
  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:

    let
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
      );

      legacyPackages = forAllSystems (system: self.packages.${system});

      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          default = pkgs.mkShellNoCC {
            name = "nix-check-shell";
            buildInputs = with pkgs; [
              jjui
              jujutsu
              lumen
              otel-tui
              pipelight-rs
              playerctl
              rootbar
            ];
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };
}
