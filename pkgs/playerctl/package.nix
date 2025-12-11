{ stable }:

stable.playerctl.overrideAttrs (final: {
  patches = [
    ./0001-fix-interface-logic.patch
  ];
})
