let
  # users
  andres-dede = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4i3B/ShuuG5zvddLbazGYNEfat3C8TF7d5ixARpHUb andres@dede";

  # systems
  dede = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeJBx110sElXuAaPFghnMqBIBSNH58xHjng5NcenKSu root@dede";
in {
  "dede-wireguard-public.age".publicKeys = [andres-dede dede];
  "dede-wireguard-private.age".publicKeys = [andres-dede dede];
}
