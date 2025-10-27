{ config, lib, pkgs, ... }:
let
  cfg = config.servicesx.navidrome;  # "servicesx" = your custom namespace
in
{
  options.servicesx.navidrome = {
    enable = lib.mkEnableOption "Navidrome music server";
    domain = lib.mkOption {
      type = lib.types.str;
      example = "music.example.com";
      description = "Public domain for Navidrome behind Caddy.";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 4533;
      description = "Local Navidrome port.";
    };
    musicDir = lib.mkOption {
      type = lib.types.path;
      example = "/srv/music";
      description = "Directory with your music library.";
    };
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/navidrome";
      description = "Navidrome app data directory.";
    };
    extraSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Extra Navidrome settings.ini key/values.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      settings = {
        Port = cfg.port;
        MusicFolder = cfg.musicDir;
        DataFolder = cfg.dataDir;
      } // cfg.extraSettings;
    };

    # Caddy vhost for the service
    services.caddy.virtualHosts."${cfg.domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}

