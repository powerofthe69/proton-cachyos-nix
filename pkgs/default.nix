{ pkgs, sources }:

pkgs.stdenv.mkDerivation {
  pname = "proton-cachyos";
  inherit (sources.proton-cachyos) version src;

  # GitHub uses .xz compression
  nativeBuildInputs = [ pkgs.xz ];

  # Standard unpackPhase works fine for .tar.xz, so we don't need a custom one.
  # But we DO need to handle the directory nesting.

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/steam/compatibilitytools.d/proton-cachyos

    # 1. Use a wildcard to copy the contents of "proton-cachyos-10.0-slr..."
    cp -r ./* $out/share/steam/compatibilitytools.d/proton-cachyos/

    # 2. Patch the Steam Name
    sed -i -r 's|"display_name".*|"display_name" "Proton CachyOS"|' \
      $out/share/steam/compatibilitytools.d/proton-cachyos/compatibilitytool.vdf

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Proton-CachyOS (x86_64-v4 SLR)";
    homepage = "https://github.com/CachyOS/proton-cachyos";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
  };
}
