{
  config,
  pkgs,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  imports = [
    ./agenix.nix
  ];

  # Enable networking
  networking.networkmanager = {
    enable = true;
    # dns = "none";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # bluetooth settings
  hardware = {
    # enables support for Bluetooth
    bluetooth.enable = true;
    # powers up the default Bluetooth controller on boot
    bluetooth.powerOnBoot = true;
  };
  # enable blueman to configure bluetooth
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;

  # set fish as default shell.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable docker and podman on all machines
  virtualisation = {
    podman = {
      enable = true;
    };
    docker = {
      enable = true;
    };
  };

  # set nvim as main editor
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    nixos-generators
    git-crypt
    thunderbird
    openconnect
    rustup
    gcc
    wget
    kitty
    git
    lshw
    zip
    bat
    ripgrep
    firefox
    inputs.agenix.packages.${system}.default
    sshfs
    emacs
    fd
    stow
    tree
    magic-wormhole-rs
    pstree
    rclone
    zotero
    bazecor
    uv
  ];

  # nix configuration settings
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
      auto-optimise-store = true;
      trusted-users = ["root" "andres"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
