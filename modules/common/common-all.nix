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
  networking.networkmanager.enable = true;

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # point DOCKER_HOST (docker socket var) to podmans default
  environment.extraInit = ''
    export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  '';

  virtualisation = {
    podman = {
      enable = true;
      # docker command -> podman
      dockerCompat = true;
      # dns for container name aliases
      defaultNetwork.settings.dns_enabled = true;
    };
    docker = {
      # enable = true;
      # if dockerCompat is true, docker cant be enabled otherwise conflict 
      enable = false;
    };
    # for virtual machines
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;      # TPM emulation (needed for some Ubuntu features)
      };
    };
  };

  programs = {
    # for virtual machines
    virt-manager.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

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
    sshfs
    fd
    tree
    pstree
    rclone
    bindfs
  ];

  programs.nix-ld.enable = true;

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
	"https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
	"cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
