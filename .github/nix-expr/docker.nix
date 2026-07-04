let
  overlay = final: prev: {
    docker-compose = prev.callPackage ../../pkgs/docker-compose/package.nix { };
  };

  pkgs = import <nixpkgs> {
    overlays = [ overlay ];
  };
in
pkgs.docker
