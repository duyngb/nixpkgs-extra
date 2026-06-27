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

      nixpkgs-for-system = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        }
      );
    in
    {
      # ----------------
      # NixPkgs Overlays
      # ----------------
      overlays = import ./overlays.nix { inherit inputs; };

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs-for-system.${system};
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
          pkgs = nixpkgs-for-system.${system};
        in
        {
          inherit (pkgs)
            jjui
            jujutsu
            llama-cpp
            llama-cpp-cuda
            lumen-diff
            otel-tui
            pipelight-rs
            playerctl
            rootbar
            terminus-vi
            ;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };
}
