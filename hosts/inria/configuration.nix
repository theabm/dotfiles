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
    ./hardware-configuration.nix
    ../../modules/profiles/base.nix
    ../../modules/profiles/laptop.nix

    ../../modules/ingress/caddy.nix
    ../../modules/services/navidrome.nix
    ../../modules/system/plasma
  ];

  ingress.caddy = {
    enable = true;
    email = "andres.bermeomarinelli@proton.me";
  };

  servicesx.navidrome = {
    enable = true;
    domain = "music.dedes-dung-pile.com";
    musicDir = "/srv/music";        # create and put FLAC/MP3 here
    dataDir  = "/var/lib/navidrome";
    # extraSettings = { LogLevel = "info"; };
  };

  # Optional: open Samba/NFS later; for now just ensure directories exist
  systemd.tmpfiles.rules = [
    "d /srv/music 0755 root root -"
    "d /var/lib/navidrome 0755 navidrome navidrome -"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "inria"; # Define your hostname.

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

  users.users.andres.packages = with pkgs; [
    kdePackages.kate
  ];

  environment.systemPackages = with pkgs; [
    zellij
    slack
    mattermost-desktop
    vscode
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
