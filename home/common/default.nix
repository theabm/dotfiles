{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "andres";
  home.homeDirectory = "/home/andres";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./neovim
    ./fish.nix
    ./kitty.nix
    # ./waybar
    ./nix.nix
  ];
  # technically I dont need this since nixvim should take care of this.

  home.packages = with pkgs; [
    black
  ];

  programs = {
    gpg.enable = true;

    ruff = {
      enable = true;
      settings = {
        line-length = 100;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    lazygit.enable = true;
  };
}
