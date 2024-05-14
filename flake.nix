{
  description = "My NixOS / HomeManager Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    neorg-overlay,
    ...
  }: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations = {
      dede = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./nixos/dede/configuration.nix

          home-manager.nixosModules.home-manager

          {
            nixpkgs.overlays = [neorg-overlay.overlays.default];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.andres.imports = [
                ./home/common
                nixvim.homeManagerModules.nixvim
              ];
            };
          }
        ];
      };
    };
  };
}
