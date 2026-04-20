{ config, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/profiles/base.nix
      ../../modules/profiles/server.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rome"; 

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

  # TODO: enable once backed by real hostnames and secrets.
  # services.grafana = {
  #   enable = true;
  #   settings.security.secret_key = "$__file{/run/agenix/grafana-secret-key}";
  # };
  #
  # services.nextcloud = {
  #   enable = true;
  #   package = pkgs.nextcloud33;
  #   hostName = "cloud.example.com";
  #   config = {
  #     dbtype = "pgsql";
  #     adminpassFile = "/run/agenix/nextcloud-admin-password";
  #   };
  # };

  users.users.andres.extraGroups = [ "libvirtd" "kvm"];
  security.sudo.wheelNeedsPassword = true;
  services.getty.autologinUser = "andres";
  environment.systemPackages = with pkgs; [];

  system.stateVersion = "24.11";
}
