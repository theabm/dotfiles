
{
  config,
  pkgs,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
in
{
  imports = [
  ];
  # user networkd for servers
  networking.useNetworkd = true;

}
