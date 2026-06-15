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
  
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };
  services.xserver = {
    enable = true;
    xkb = {
      layout = "it";
      variant = "";
    };
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

    obsidian
    discord
    spotify

    # gui
    thunderbird
    firefox
    zotero

    # programming related
    rustup
    gcc
    uv

    # editors
    vscode

    # tui
    kitty
    stow

    # utils
    alsa-utils
    alsa-ucm-conf
    ente-auth

    # wl
    wl-clipboard
  ];
}
