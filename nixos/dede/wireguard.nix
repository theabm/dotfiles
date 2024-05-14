{
  config,
  pkgs,
  lib,
  ...
}: {
  # CLIENT CONFIGURATIOn
  networking = let
    port = 53720;
  in {
    # Open ports
    firewall = {
      allowedUDPPorts = [port];
    };

    wg-quick.interfaces = {
      wg0 = {
        address = ["10.9.7.2/24"];

        dns = ["192.168.1.101"];

        privateKeyFile = "/home/andres/wireguard-keys/private";

        listenPort = port;

        peers = [
          {
            # name = "server";
            publicKey = "jQWhJHsCIT5THzRu0vphJ5kbQv8UVqgj9Orrgv/68gk=";
            # allowedIPs = ["10.9.7.1/32"];
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "212.216.136.157:${builtins.toString port}";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
