{
  config,
  pkgs,
  lib,
  ...
}: {
  # CLIENT CONFIGURATIOn
  networking = let
    port = 51820;
  in {
    # Open ports
    firewall = {
      allowedUDPPorts = [port];
    };

    wireguard.interfaces.wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = ["10.10.10.2/24"];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = port;

      privateKeyFile = "/home/andres/wireguard-keys/private";

      peers = [
        {
          name = "server";
          publicKey = "4cxMtehccXYPILDgrvVc+/neazpgY361Z7fsURDjxHQ=";
          allowedIPs = ["10.10.10.1/32"];
          endpoint = "95.246.218.120:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
