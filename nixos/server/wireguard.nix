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
          # dede - laptop
          publicKey = "ZFhTIwcZmjMjJaYw2nLx4Q3baHeW33F+UGuu5yfzWBI=";
          allowedIPs = ["10.10.10.2/32"];
        }
      ];
    };
  };
}
