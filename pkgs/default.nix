{
  pkgs,
  source,
  variant,
}:

pkgs.stdenv.mkDerivation {
  # If variant is "base", keep the name simple. Otherwise append the micro-architecture.
  pname = if variant == "base" then "proton-cachyos" else "proton-cachyos-${variant}";
  version = pkgs.lib.removePrefix "cachyos-" source.version;

  inherit (source) src;

  nativeBuildInputs = [ pkgs.xz ];

  installPhase = ''
    runHook preInstall

    # Determine folder name based on variant
    local folderName="proton-cachyos"
    if [ "${variant}" != "base" ]; then
      folderName="proton-cachyos-${variant}"
    fi

    # 2. Create the unique directory
    mkdir -p $out/share/steam/compatibilitytools.d/$folderName
    cp -r ./* $out/share/steam/compatibilitytools.d/$folderName/

    # 3. Patch the Display Name so it shows up clearly in Steam
    local uiName="Proton CachyOS"
    if [ "${variant}" != "base" ]; then
      uiName="Proton CachyOS ${variant}"
    fi

    sed -i -r "s|\"display_name\".*|\"display_name\" \"$uiName\"|" \
      $out/share/steam/compatibilitytools.d/$folderName/compatibilitytool.vdf

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Proton-CachyOS ${variant}";
    homepage = "https://github.com/CachyOS/proton-cachyos";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
  };
}
