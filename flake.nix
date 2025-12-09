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

      # 1. Load the sources file you generated with nvfetcher
      sources = pkgs.callPackage ./pkgs/_sources/generated.nix { };
    in
    {
      packages.${system} = {
        # 2. Build the package
        proton-cachyos = pkgs.callPackage ./pkgs/default.nix {
          inherit sources;
        };

        # Set it as the default so you can just run 'nix build'
        default = self.packages.${system}.proton-cachyos;
      };

      # 3. Create an overlay (This is how you will install it later)
      overlays.default = final: prev: {
        proton-cachyos = self.packages.${system}.proton-cachyos;
      };
    };
}
