{ config, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/common/common-all.nix
      ../../modules/common/common-server.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rome"; 

  networking.networkmanager.enable = true;

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

  services.xserver.xkb = {
    layout = "it";
  };
  console.useXkbConfig = true;

  services.paperless.enable = true;
  services.karakeep.enable = true;
  services.actual.enable = true;
  services.immich.enable = true;
  services.grafana.enable = true;
  services.nextcloud.enable = true;

  users.users.andres = {
    isNormalUser = true;
    description = "andres";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm"];
    packages = with pkgs; [];
  };
  security.sudo.wheelNeedsPassword = true;
  services.getty.autologinUser = "andres";
  environment.systemPackages = with pkgs; [];

  system.stateVersion = "24.11";
}
