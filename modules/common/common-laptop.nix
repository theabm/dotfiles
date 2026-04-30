{
  pkgs,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  networking.networkmanager.plugins = [
    pkgs.networkmanager-openconnect
    pkgs.networkmanager-openvpn
  ];
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      # powers up the default Bluetooth controller on boot
      powerOnBoot = true;
    };
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # enable blueman to configure bluetooth
  # leads to duplicate icons in KDE
  services.blueman.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.symbols-only
  ];

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vlc
    feh

    # management
    nixos-generators

    # gui
    thunderbird
    firefox
    zotero
    qownnotes

    # programming related
    rustup
    gcc
    uv

    # editors
    vscode

    # tui
    kitty
    localsend
    stow
    bat

    # utils
    alsa-utils
    alsa-ucm-conf
    ente-auth

    # wl
    wl-clipboard
  ];
}
