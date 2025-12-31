# This repo will continue to be maintained as it does not have a large overhead, but I have stood up a (currently, slightly) larger NUR that includes the proton-cachyos packages as well as a module for Nix installation of mesa-git (cached!), and packages for vintage-story, pokemmo, and whatever else I decide to update. I recommend using that!




Personal flake for Proton-CachyOS

This is made for personal use, but I've made the repo public for anyone that may not want to maintain their own. My original intent was to only grab the x86-64 v4 microarchitecture of proton-cachyos, but I added all the different microarchitectures too, as it wasn't much more work than what was already established, and I know that others may not have an x86-64 v4 supported CPU, or may prefer the regular package.

I could stop maintaining this for myself at any point.

Enable this repo in your flake.nix inputs using `proton-cachyos.url = "github:powerofthe69/proton-cachyos-nix";`.

Enable the overlay using `nixpkgs.overlays = [ proton-cachyos.overlays.default ];`.

All packages maintain the same structure for installation, that being:

`programs.steam.extraCompatPackages = with pkgs; [ proton-cachyos ];`

`programs.steam.extraCompatPackages = with pkgs; [ proton-cachyos-x86_64_v2 ];`

`programs.steam.extraCompatPackages = with pkgs; [ proton-cachyos-x86_64_v3 ];`

`programs.steam.extraCompatPackages = with pkgs; [ proton-cachyos-x86_64_v4 ];`
