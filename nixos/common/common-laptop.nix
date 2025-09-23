{
  config,
  pkgs,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
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

  services.emacs = {
    enable = true;
  };

  # bluetooth settings
  hardware = {
    # enables support for Bluetooth
    bluetooth = {
      enable = true;
      # powers up the default Bluetooth controller on boot
      powerOnBoot = true;
    };
  };

  # enable blueman to configure bluetooth
  services.blueman.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.symbols-only
  ];

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    nixos-generators
    thunderbird
    rustup
    gcc
    kitty
    firefox
    emacs
    stow
    magic-wormhole-rs
    zotero
    bazecor
    uv
    localsend
    pipewire
    wireplumber
    alsa-utils
    alsa-ucm-conf
  ];
}
