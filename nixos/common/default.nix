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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
    (nerdfonts.override {fonts = ["Hack"];})
    font-awesome
  ];

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    thunderbird
    openconnect
    wget
    kitty
    git
    lshw
    zip
    bat
    ripgrep
    firefox
    # nvtopPackages.full
    inputs.agenix.packages.${system}.default
    sshfs
    emacs
    fd
  ];

  # nix configuration settings
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
      auto-optimise-store = true;
      trusted-users = ["root" "andres"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
