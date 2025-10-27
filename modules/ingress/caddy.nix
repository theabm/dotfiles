{ config, lib, pkgs, ... }:
let
  cfg = config.ingress.caddy;
in
{
  options.ingress.caddy = {
    enable = lib.mkEnableOption "Enable Caddy as reverse proxy";
    email = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Email for ACME/Let’s Encrypt (Caddy).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      email = cfg.email;
    };
    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}

