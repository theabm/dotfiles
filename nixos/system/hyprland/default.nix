{
  config,
  pkgs,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "andres";
  };

  # sddm is shit - prefer gdm
  # services.displayManager.sddm = {
  #   enable = true;
  #   settings = {
  #     General = {
  #       DefaultSession = "hyprland.desktop";
  #     };
  #   };
  #   theme = "sugar-dark";
  # };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  qt.enable = true;
  programs.hyprlock.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    mako
    kdePackages.qtwayland
    libsForQt5.qt5.qtwayland
    kdePackages.polkit-kde-agent-1
    waybar
    swww
    clipboard-jh
    wlogout
    playerctl
    brightnessctl
    networkmanagerapplet
    wallust
    fuzzel
    libpng
  ];
}
