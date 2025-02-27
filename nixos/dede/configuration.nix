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
    ../common/common.nix
    ../common/common-laptop.nix

    # system options
    ../system/plasma
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dede";

  time.timeZone = "Europe/Rome";
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

  services.xserver = {
    enable = true;
    xkb = {
      layout = "it";
      variant = "";
    };
  };
  console.keyMap = "it2";

  users.users.andres = {
    isNormalUser = true;
    description = "andres";
    extraGroups = ["networkmanager" "wheel" "uucp" "dialout" "audio"];
    packages = [];
  };

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeJBx110sElXuAaPFghnMqBIBSNH58xHjng5NcenKSu";
  age.secrets."s1".rekeyFile = ./s1.age;

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    bat
    zellij
    zathura
    feh
    zotero
    signal-desktop
    vlc
    bazecor
    ollama-cuda
    ardour
    ente-auth
  ];

  # used for ardour
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
