{
  config,
  pkgs,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
in
{
  imports = [
  ];

  networking.networkmanager = {
    enable = true;
    plugins = [
      pkgs.networkmanager-openconnect
      pkgs.networkmanager-openvpn
    ];
  };

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  virtualisation = {
    podman = {
      enable = true;
    };
    docker = {
      enable = true;
    };
  };

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  environment.systemPackages = with pkgs; [
    jq
    git-crypt
    envsubst
    wget
    git
    lshw
    zip
    bat
    ripgrep
    inputs.agenix.packages.${system}.default
    wireguard-tools
    sshfs
    fd
    tree
    pstree
    rclone
  ];

  # all hosts will be connected with tailscale
  services.tailscale = {
    enable = true;
    port = 61503;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # global settings for all hosts
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto";
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "andres"
      ];
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
