{
  config,
  lib,
  ...
}: let
  cfg = config.local.networkProfiles.eduroam;
in {
  options.local.networkProfiles.eduroam = {
    enable = lib.mkEnableOption "the Inria eduroam NetworkManager profile";

    identity = lib.mkOption {
      type = lib.types.str;
      description = "The Inria eduroam inner identity, usually your institutional login or email address.";
    };

    interfaceName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "wlp2s0";
      description = "Wireless interface to bind the eduroam profile to. Set to null to allow any Wi-Fi interface.";
    };

    anonymousIdentity = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The anonymous outer identity sent before the encrypted eduroam login. Leave blank to match nm-connection-editor.";
    };

    caCert = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Optional CA certificate used to validate the eduroam authentication server.";
    };

    disableWifiPowersave = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Disable NetworkManager Wi-Fi power saving, which can help with periodic disconnects on some laptop chipsets.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.wifi.powersave = lib.mkIf cfg.disableWifiPowersave false;

    networking.networkmanager.ensureProfiles.profiles.eduroam = {
      connection =
        {
          id = "eduroam";
          type = "wifi";
          autoconnect = true;
          permissions = "";
        }
        // lib.optionalAttrs (cfg.interfaceName != null) {
          interface-name = cfg.interfaceName;
        };

      wifi = {
        mode = "infrastructure";
        ssid = "eduroam";
      };

      wifi-security.key-mgmt = "wpa-eap";

      "802-1x" =
        {
          eap = "peap;";
          identity = cfg.identity;
          phase2-auth = "mschapv2";
          password-flags = 1;
          system-ca-certs = cfg.caCert != null;
        }
        // lib.optionalAttrs (cfg.anonymousIdentity != "") {
          anonymous-identity = cfg.anonymousIdentity;
        }
        // lib.optionalAttrs (cfg.caCert != null) {
          ca-cert = toString cfg.caCert;
        };

      ipv4.method = "auto";
      ipv6 = {
        addr-gen-mode = "stable-privacy";
        method = "auto";
      };
    };
  };
}
