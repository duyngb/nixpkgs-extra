{
  lib,
  fetchFromGitHub,
  buildGoModule,

  doCheck ? false,
  doInstallCheck ? false,
}:

buildGoModule (final: {
  pname = "fastschema";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "fastschema";
    repo = "fastschema";
    tag = "v${final.version}";
    hash = "sha256-LQiGvOZRwF3dXMGYReYpWtujOtljl0dtrb3EUvehJKw=";
  };

  vendorHash = "sha256-0rSv47vo2JRJm2iPG4C8RQRJWNArPp1hh+P015cOX7Q=";

  preBuild = ''
    mkdir -p cmd/fastschema
    mv -t cmd/fastschema cmd/main.go
  '';

  subPackages = [ "cmd/fastschema" ];

  inherit doCheck doInstallCheck;

  meta = {
    description = "all-in-one backend-as-a-service with headless cms";
    license = lib.licenses.mit;
    mainProgram = "fastschema";
  };
})
