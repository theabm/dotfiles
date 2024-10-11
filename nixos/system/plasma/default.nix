{
config, 
pkgs,
inputs,
...
}: let 
  system = "x86_64-linux";
in {

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [ ];


}
