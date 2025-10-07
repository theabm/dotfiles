{
  config,
  pkgs,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  services.displayManager.autoLogin = {
    enable = true;
    user = "andres";
  };

  # sddm is shit - prefer gdm
  # other options that work well according to hyprland doc
  # greetd 
  # ly
  services.xserver.displayManager.gdm.enable = true;

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
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  qt.enable = true;
  programs.hyprlock.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    # notification system
    mako
    # libraries for Qt support
    kdePackages.qtwayland
    libsForQt5.qt5.qtwayland
    # needed for authentication, as alternative use hyprpolkitagent
    kdePackages.polkit-kde-agent-1
    # status bar
    waybar
    # wallpaper control at runtime
    swww
    # clipboard
    clipboard-jh
    # wayland logout
    wlogout
    # control music
    playerctl
    # control brightness 
    brightnessctl
    # network manager
    networkmanagerapplet
    # generate colors
    wallust
    # launcher 
    fuzzel
    libpng
    # GUI file manager (useful sometimes)
    kdePackages.dolphin
    # managing soundcards, volume, etc.
    pavucontrol
    # utilities for screenshot: 
    # (grim: grab screen, slurp: select region, wl-clipboard: copy to clipboard, 
    # swappy: crop/annotate after capture)
    grim slurp wl-clipboard swappy
  ];
}
