{
  config,
  pkgs,
  inputs,
  # uncomment when using hybrid setup
  # unstable,
  ...
}: let
  system = "x86_64-linux";
in {
  imports = [
    ./hardware-configuration.nix

    # common options 
    ../../modules/common/common-all.nix
    ../../modules/common/common-laptop.nix

    # system specific options
    ../../modules/system/hyprland
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dede";

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
  console.keyMap = "it2";
  services.hardware.bolt.enable = true;

  # services.gnome.gnome-keyring.enable = true;

  users.users.andres = {
    isNormalUser = true;
    description = "andres";
    extraGroups = [
      "networkmanager"
      "wheel"
      # ardour
      "uucp"
      "dialout"
      "audio"
      # qemu / kvm
      "libvirtd"
      "kvm"
      "input"
      # brighness
      "i2c"
    ];
    packages = [];
  };

  # define a secret
  age.secrets = {
    "wg-private" = {
      file = ../../secrets/dede-wireguard-private.age;
      mode = "640";
      group = "systemd-network";
    };
    "wg-public" = {
      file = ../../secrets/dede-wireguard-public.age;
      mode = "640";
      group = "systemd-network";
    };
  };

  programs.steam.enable = true;
  programs.kdeconnect.enable = true;
  programs.tmux = {
    enable = true;
    keyMode = "vi";

  };
  environment.systemPackages = with pkgs; [
    signal-desktop
    discord
    spotify

    bazecor
    ardour
    obsidian

    nvtopPackages.full

    # programming IDE
    jetbrains.pycharm
    opencode
    code-cursor
    vscode

    # book
    foliate
    calibre

    kdePackages.okular
    bindfs

    # voxtype (speech to text)
    voxtype-vulkan
    wtype

    # productivity
    super-productivity

    # brightness control
    ddcutil
  ];

  # used for ardour DAW
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
  ];

  # bridghtness control
  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [
    "modesetting"
    "amdgpu"
    "nvidia"
  ];
  services = {
    asusd.enable = true;
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
       KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
       KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
       KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
    '';
  };
  hardware.amdgpu.initrd.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      # NOTE It is required to set one of these, otherwise at boot time I get a black screen.

      # OPTION A - Sync Mode: better performance and reduced
      # screen tearing.
      # the nvidia GPU is not put to sleep completely unless called for.
      # Result: when I use an external monitor (which is often) this option works better
      # as it eliminates flickering and tearing.
      # sync.enable = true;

      # Option B - Offload Mode: puts nvidia GPU to sleep and let amd gpu
      # handle all tasks except by specifically offloading an application to it.
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
