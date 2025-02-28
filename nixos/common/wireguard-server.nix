{
  config,
  lib,
  pkgs,
  ...
}: let
  wgName = "20-wg0";
in {
  environment.systemPackages = with pkgs; [
    wireguard-ui
    wireguard-tools
  ];

  networking.firewall.allowedUDPPorts = [51820];
  networking.useNetworkd = true;

  systemd.network = {
    # use networkd - systemd networking
    enable = true;

    # netdev config - this creates a virtual network device (an interface that is not physical
    # like eth0). Think of this as "creating the network card"
    netdevs = {
      ${wgName} = {
        # All options can be found in:
        # https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html

        # general netdev config
        netdevConfig = {
          Kind = "wireguard";
          Description = "Wireguard network device configuration. Setup in dotfiles/nixos/common/wireguard-server.nix";
          Name = "wg0";
          MTUBytes = "1420";
        };
        # wireguard config
        wireguardConfig = {
          PrivateKeyFile = "/home/andres/wireguard/privatekey";
          FirewallMark = 2424;
          ListenPort = 51820;
          # RouteTable=200;
        };
        wireguardPeers = [
          {
            PublicKey = "ZFhTIwcZmjMjJaYw2nLx4Q3baHeW33F+UGuu5yfzWBI=";
            AllowedIPs = ["10.10.10.2/32"];
            # Endpoint = "wg.dedes-dung-pile.com:51820";
            PersistentKeepalive = 25;
            # RouteTable = 200;
          }
          {
            PublicKey = "ICAgHCGpp5ZrWfj3NwPpNcHMbrfJI/0pyuAZ6+ElZDA=";
            AllowedIPs = ["10.10.10.3/32"];
            # Endpoint = "wg.dedes-dung-pile.com:51820";
            PersistentKeepalive = 25;
            # RouteTable = 200;
          }
        ];
      };
    };
    # once the interface/device exists, we need to configure how it behaves (IP address, forwarding
    # rules, etc.)
    networks.${wgName} = {
      # match settings to the name of the interface - in our case it is wg0
      matchConfig.Name = config.systemd.network.netdevs.${wgName}.netdevConfig.Name;

      # address of the server
      address = ["10.10.10.1/32"];

      # networkConfig = {
      # IPMasquerade = "ipv4";
      # IPv4Forwarding = true;
      # };
    };
  };
}
