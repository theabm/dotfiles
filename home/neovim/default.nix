{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;

    wrapRc = true;

    clipboard.providers.wl-copy.enable = true;

    # color scheme
    colorschemes.tokyonight = {
      enable = true;
      style = "night";
    };
  };
}
