{
  outputs =
    inputs@{ nixpkgs, ... }:

    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];

      overlays = import ./overlays.nix;

      nixpkgs-for-system = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ overlays.default ];
          config.allowUnfree = true;
        }
      );

      nixpkgs-for = system: nixpkgs-for-system.${system};
    in
    {
      inherit overlays;

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs-for system;
        in
        nixpkgs.lib.packagesFromDirectoryRecursive {
          callPackage = nixpkgs.lib.callPackageWith pkgs;
          directory = ./pkgs;
        }
      );

      legacyPackages = forAllSystems nixpkgs-for;

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs-for system;
        in
        {
          inherit (pkgs)
            encoredev
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

      formatter = forAllSystems (system: (nixpkgs-for system).nixfmt-tree);
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };
}
