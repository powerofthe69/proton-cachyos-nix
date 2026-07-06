{
  description = "Personal NUR for Proton-CachyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # FSR4 amdxcffx64.dll is unfree
        config.allowUnfree = true;
      };
      sources = pkgs.callPackage ./pkgs/_sources/generated.nix { };

      mkProton =
        sourceKey: variantName:
        pkgs.callPackage ./pkgs/default.nix {
          source = sources.${sourceKey};
          variant = variantName;
        };

      proton = mkProton "proton-cachyos" "base";
      protonv3 = mkProton "proton-cachyos-x86_64-v3" "x86_64-v3";

    in
    {
      packages.${pkgs.stdenv.hostPlatform.system} = {
        proton-cachyos = proton;

        proton-cachyos-x86_64-v3 = protonv3;
        # Deprecated aliases (w/ underscores) for backwards compatibility
        proton-cachyos-x86_64_v3 = protonv3;

        default = proton;
      };

      overlays.default = final: prev: {
        proton-cachyos = self.packages.${final.stdenv.hostPlatform.system}.proton-cachyos;
        proton-cachyos-x86_64-v3 =
          self.packages.${final.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v3;

        # Deprecated aliases w/ underscores
        proton-cachyos-x86_64_v3 =
          self.packages.${final.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v3;
      };
    };
}
