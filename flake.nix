# flake.nix
#
# Author:       Colin Uken <contact@cuken.dev>
# URL:          https://github.com/cuken/nixos-config
# License:      MIT
#
# Hic sunt dracones.

{
  description = "Cuken's NixOS and MacOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:cuken/nixpkgs/master";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, darwin, home-manager, nixpkgs, ...}@inputs: {
    darwinConfigurations = {
      "AA-MBP" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin
        ];
        inputs = { inherit darwin home-manager nixpkgs; };
      };
    };
    nixosConfigurations = {
      fenrir = nixpkgs.lib.nixosSystem {
        system = "x64_64-linux";
        modules = [
          ./nixos
          ./hardware/fenrir.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cuken = import ./nixos/home-manager.nix;
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
