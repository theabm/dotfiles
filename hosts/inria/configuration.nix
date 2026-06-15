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

  networking.hostName = "inria"; # Define your hostname.

  users.users.andres.packages = with pkgs; [
    kdePackages.kate
  ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.full

  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
