{
  description = "Personal NUR for Proton-CachyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      sources = pkgs.callPackage ./pkgs/_sources/generated.nix { };

      mkProton =
        sourceKey: variantName:
        pkgs.callPackage ./pkgs/default.nix {
          source = sources.${sourceKey};
          variant = variantName;
        };
    in
    {
      packages.${system} = {
        # Base has no suffix
        proton-cachyos = mkProton "proton-cachyos" "base";

        # "Attribute Name"             = mkProton "Source Key (from nvfetcher)"   "Variant Name"
        "proton-cachyos-x86_64_v2" = mkProton "proton-cachyos-x86_64_v2" "x86_64_v2";
        "proton-cachyos-x86_64_v3" = mkProton "proton-cachyos-x86_64_v3" "x86_64_v3";
        "proton-cachyos-x86_64_v4" = mkProton "proton-cachyos-x86_64_v4" "x86_64_v4";

        # Update the default to match the new name
        default = self.packages.${system}.proton-cachyos;
      };

      overlays.default = final: prev: {
        proton-cachyos = self.packages.${system}.proton-cachyos;
        "proton-cachyos-x86_64_v2" = self.packages.${system}."proton-cachyos-x86_64_v2";
        "proton-cachyos-x86_64_v3" = self.packages.${system}."proton-cachyos-x86_64_v3";
        "proton-cachyos-x86_64_v4" = self.packages.${system}."proton-cachyos-x86_64_v4";
      };
    };
}
