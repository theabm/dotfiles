{
  config, 
  pkgs,
  inputs,
  ...
}: let 
  system = "x86_64-linux";
in {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  }

  environment.systemPackages = with pkgs; [ 
    kitty
  ];


}
