let
  # users
  andres-dede = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4i3B/ShuuG5zvddLbazGYNEfat3C8TF7d5ixARpHUb andres@dede";
  andres-franky = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4585gq7FnkvtpK08kRNCB7jjPYBCD0N5GuxZw39pcD andres@franky";

  # systems
  dede = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeJBx110sElXuAaPFghnMqBIBSNH58xHjng5NcenKSu root@dede";
  franky = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjGOUqNRFJVBNVd3xKHhMO/OyuHk+Q7AgpTbvWkcnPk root@nixos";
in {
  "dede-wireguard-public.age".publicKeys = [andres-dede dede];
  "dede-wireguard-private.age".publicKeys = [andres-dede dede];

  "franky-wireguard-public.age".publicKeys = [andres-franky franky];
  "franky-wireguard-private.age".publicKeys = [andres-franky franky];
}
