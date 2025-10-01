{
  inputs,
  system,
  fetchFromGitHub,
}:

let
  basepkg = inputs.nixpkgs.legacyPackages.${system}.neovim-unwrapped;
  version = "0.11.4";
  hash = "sha256-IpMHxIDpldg4FXiXPEY2E51DfO/Z5XieKdtesLna9Xw=";
  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    tag = "v${version}";
    hash = "${hash}";
  };
in

basepkg.overrideAttrs (old: {
  inherit version src;
})
