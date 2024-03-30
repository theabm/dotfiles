# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  sddm_theme = let
    image = pkgs.fetchurl {
      url = "https://github.com/theabm/wallpapers/blob/main/one-piece-nika-moon.jpg?raw=true";
      sha256 = "sha256-MDznlZFHT+GjpD6TuUNYW+Us3Us7Hssnieiqx5OIIhc=";
    };
  in
    pkgs.sddm-chili-theme.overrideAttrs {
      postInstall = ''
        mkdir -p $out/share/sddm/themes/chili

        mv * $out/share/sddm/themes/chili/

        cd $out/share/sddm/themes/chili/

        rm assets/background.jpg

        cat ${image} >> tmp.txt

        cp -r ${image} $out/share/sddm/themes/chili/assets/background.jpg


      '';
    };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # according to hyprland, I should add this to my configuration. However, I think
  # it works better without this setting.
  # boot.kernelParams = [
  #       "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  #       "nvidia_drm.modeset=1"
  # ];

  boot.initrd.luks.devices."luks-899e1d08-30b0-422d-a760-389d75acadf2".device = "/dev/disk/by-uuid/899e1d08-30b0-422d-a760-389d75acadf2";
  networking.hostName = "dede"; # Define your hostname.

  # Enables wireless support via wpa_supplicant.
  # networking.wireless = {
  # enable = true;
  # userControlled.enable = true;
  # };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "it";
      variant = "";
    };
    displayManager.sddm = {
      enable = true;
      theme = "${sddm_theme}/share/sddm/themes/chili";
    };
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable sound with pipewire.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andres = {
    isNormalUser = true;
    description = "andres";
    extraGroups = ["networkmanager" "wheel" "uucp" "dialout"];
    packages = with pkgs; [
      firefox
      nvtop
      bazecor
      signal-desktop
      exercism
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    kitty
    mako
    swww
    rofi-wayland
    git
    networkmanagerapplet
    wlogout
    lshw
    zip
    pywal
    rustup
    zellij
    bat
    ripgrep
    gcc
    zathura
    feh
    sddm_theme
    zotero
    mullvad-vpn
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Hack"];})
    font-awesome
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdgOpenUsePortal = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      # NOTE: It is required to set one of these, otherwise at boot time I get a black screen.

      # OPTION A - Sync Mode: better performance and reduced
      # screen tearing.
      # the nvidia GPU is not put to sleep completely unless called for.
      # Result: when I use an external monitor (which is often) this option works better
      # as it eliminates flickering and tearing.
      sync.enable = true;

      # Option B - Offload Mode: puts nvidia GPU to sleep and let amd gpu
      # handle all tasks except by specifically offloading an application to it.
      # offload = {
      # 	enable = true;
      # 	enableOffloadCmd = true;
      # };

      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
