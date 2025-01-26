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

    # utilities
    # ./wireguard.nix

    # common options imported for all configurations
    ../common

    # system options
    ../system/plasma
    # ../system/hyprland
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages;

  boot.initrd.luks.devices."luks-899e1d08-30b0-422d-a760-389d75acadf2".device = "/dev/disk/by-uuid/899e1d08-30b0-422d-a760-389d75acadf2";
  networking.hostName = "dede"; # Define your hostname.

  # plays with DNS option in networking. Look at common/default.nix
  # look at encrypted DNS for nixOS wiki
  # networking = {
  #   nameservers = ["127.0.0.1" "192.168.1.101"];
  # };
  # this needs to be set to false for above as well
  # services.resolved.enable = false;

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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "it";
      variant = "";
    };
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andres = {
    isNormalUser = true;
    description = "andres";
    extraGroups = ["networkmanager" "wheel" "uucp" "dialout" "audio"];
    packages = [];
  };

  # agenix settings
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeJBx110sElXuAaPFghnMqBIBSNH58xHjng5NcenKSu";
  age.secrets."s1".rekeyFile = ./s1.age;

  programs.steam.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    zellij
    zathura
    feh
    zotero
    signal-desktop
    wireguard-tools
    vlc
    bazecor
    ollama-cuda
    ardour
    ente-auth
  ];

  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
  ];

  # new option for opengl
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      # NOTE: It is required to set one of these, otherwise at boot time I get a black screen.

      # OPTION A - Sync Mode: better performance and reduced
      # screen tearing.
      # the nvidia GPU is not put to sleep completely unless called for.
      # Result: when I use an external monitor (which is often) this option works better
      # as it eliminates flickering and tearing.
      sync.enable = true;

      # Option B - Offload Mode: puts nvidia GPU to sleep and let amd gpu
      # handle all tasks except by specifically offloading an application to it.
      # offload = {
      # 	enable = true;
      # 	enableOffloadCmd = true;
      # };

      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
