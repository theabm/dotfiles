{
  description = "My NixOS / HomeManager Config";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      agenix,
      noctalia,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      andresHomeManager = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.andres.imports = [
            ./home/common
            nixvim.homeModules.nixvim
          ];
        };
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

      nixosConfigurations = {
        dede = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./hosts/dede/configuration.nix
            ./modules/system/noctalia

            agenix.nixosModules.default

            home-manager.nixosModules.home-manager
            andresHomeManager
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
            andresHomeManager
          ];
        };
      };
    };
}
