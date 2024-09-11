# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "inria"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "it";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware = {
    # enables support for Bluetooth
    bluetooth.enable = true;
    # powers up the default Bluetooth controller on boot
    bluetooth.powerOnBoot = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andres = {
    isNormalUser = true;
    description = "Andres";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    thunderbird
    openconnect
    wget
    kitty
    git
    networkmanagerapplet
    lshw
    zip
    rustup
    zellij
    bat
    ripgrep
    zathura
    feh
    zotero
    nvtopPackages.full
    bazecor
    signal-desktop
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  virtualisation.docker.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Hack"];})
    font-awesome
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
      auto-optimise-store = true;
      trusted-users = ["root" "andres"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
