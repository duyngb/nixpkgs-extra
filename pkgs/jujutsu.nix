{
  fetchFromGitHub,
  rustPlatform,
  stable,
}:

stable.jujutsu.overrideAttrs (final: rec {
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "jj-vcs";
    repo = "jj";
    tag = "v${version}";
    hash = "sha256-ojhsg083nb/GWzNIaLzCg0/9hdCHkb3xdrvGqxhNDmY=";
  };

  cargoHash = "sha256-RrIZS8BjG4a4sKgXdYF/kgq2saRMXjr8Ao6lOCJMmtU=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoHash;
  };

  doCheck = false;
  doInstallCheck = false;
})
