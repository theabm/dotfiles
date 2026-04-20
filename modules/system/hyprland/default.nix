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
  services.displayManager.gdm.enable = true;

  # services.sddm = {
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
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  qt.enable = true;
  programs.hyprlock.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    # libraries for Qt support
    kdePackages.qtwayland
    libsForQt5.qt5.qtwayland
    # needed for authentication, as alternative use hyprpolkitagent
    kdePackages.polkit-kde-agent-1
    kdePackages.gwenview

    quickshell
    # wallpaper control at runtime
    awww
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

    libpng
    # managing soundcards, volume, etc.
    pavucontrol

    hyprshot
  ];
}
