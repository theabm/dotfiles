{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "franky"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
  };
  console.useXkbConfig=true;

  users.users.andres = {
    isNormalUser = true;
    description = "Andres";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  security.sudo.wheelNeedsPassword= true;


  services.getty.autologinUser = "andres";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim 
    git
  ];

  services.openssh= {
  	enable = true;
	settings = {
		#PasswordAuthentication=false;
		KbdInteractiveAuthentication=false;
	};
  };

  system.stateVersion = "24.11"; 

  nix = {
	settings = {
		trusted-users = ["root"];
		experimental-features = ["nix-command" "flakes"];

	};

  };

}
