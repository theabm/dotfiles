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

    # neorg-overlay = {
    #   url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    # neorg-overlay,
    agenix,
    agenix-rekey,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nodes = self.nixosConfigurations;
    };

    nixosConfigurations = {
      dede = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {inherit inputs;};

        modules = [
          ./nixos/dede/configuration.nix

          agenix.nixosModules.default

          home-manager.nixosModules.home-manager

          {
            # nixpkgs.overlays = [neorg-overlay.overlays.default];
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

      inria = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {inherit inputs;};

        modules = [
          ./nixos/inria/configuration.nix

          agenix.nixosModules.default

          home-manager.nixosModules.home-manager

          {
            # nixpkgs.overlays = [neorg-overlay.overlays.default];
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
