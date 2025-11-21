{
  description = "My NixOS / HomeManager Config";

  inputs = {
    # uncomment when using hybrid setup
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # rename to nixpkgs-unstable when using hybrid setup
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      # uncomment when using hybrid setup
      # nixpkgs-unstable,
      home-manager,
      nixvim,
      agenix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

      nixosConfigurations = {
        dede = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
            # uncommentn when using hybrid setup
            # unstable = nixpkgs-unstable.legacyPackages.${system};
          };

          modules = [
            ./hosts/dede/configuration.nix

            agenix.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.andres.imports = [
                  ./home/common
                  nixvim.homeModules.nixvim
                ];
              };
            }
          ];
        };

        rome = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/rome/configuration.nix

            agenix.nixosModules.default

          ];
        };

        inria = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/inria/configuration.nix

            agenix.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.andres.imports = [
                  ./home/common
                  nixvim.homeModules.nixvim
                ];
              };
            }
          ];
        };
      };
    };
}
