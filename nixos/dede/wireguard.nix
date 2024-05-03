{
  config,
  pkgs,
  lib,
  ...
}: {
  networking = let
    port = 51820;
  in {
    # Open ports
    firewall = {
      allowedUDPPorts = [port];
    };

    wireguard.interfaces.wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = ["10.10.10.1/24"];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = port;

      privateKeyFile = "/home/andres/wireguard-keys/private";

      peers = [
        {
          # phone
          publicKey = "p1zk+7PJQ/3LeuqycMsjiKlC1fdHDc2HGYM6r32Ki2k=";
          allowedIPs = ["10.10.10.2/32"];
        }
      ];
    };
  };
}
