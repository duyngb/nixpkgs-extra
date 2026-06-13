{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  bdftopcf,
  fonttosfnt,
  libfaketime,
  mkfontscale,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminus-vi-font";
  version = "4.48.0";

  src = fetchFromGitHub {
    owner = "bachan";
    repo = "terminus-font-vietnamese";
    rev = "b30cb464c56c4efd9a42f75985e5d0a360ce058f";
    hash = "sha256-2kr6H091rzOV7P2KHiEIGumzeXuQ3djGQqNEz4n5pJA=";
  };

  patches = [ ];

  nativeBuildInputs = [
    python3
    bdftopcf
    libfaketime
    fonttosfnt
    mkfontscale
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile --replace 'fc-cache' '#fc-cache'
    substituteInPlace Makefile --replace 'gzip'     'gzip -n'
  '';

  postBuild = ''
    for i in *.bdf; do
      name=$(basename $i .bdf)
      faketime -f "1970-01-01 00:00:01" \
      fonttosfnt -v -o "$name.otb" "$i"
    done
  '';

  postInstall = ''
    install -m 644 -D *.otb -t "$out/share/fonts/misc"
    mkfontdir "$out/share/fonts/misc"
  '';

  installTargets = [
    "install"
    "fontdir"
  ];
  # fontdir depends on the previous two targets, but this is not known
  # to make, so we need to disable parallelism:
  enableParallelInstalling = false;

  meta = {
    description = "Clean fixed width font";
    longDescription = ''
      Terminus Font is designed for long (8 and more hours per day) work
      with computers. Version 4.30 contains 850 characters, covers about
      120 language sets and supports ISO8859-1/2/5/7/9/13/15/16,
      Paratype-PT154/PT254, KOI8-R/U/E/F, Esperanto, many IBM, Windows and
      Macintosh code pages, as well as the IBM VGA, vt100 and xterm
      pseudographic characters.

      The sizes present are 6x12, 8x14, 8x16, 10x20, 11x22, 12x24, 14x28 and
      16x32. The styles are normal and bold (except for 6x12), plus
      EGA/VGA-bold for 8x14 and 8x16.
    '';
    homepage = "https://terminus-font.sourceforge.net/";
    license = lib.licenses.ofl;
    maintainers = [ ];
  };
})
