{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    wrapRc = true;

    clipboard.providers.wl-copy.enable = true;

    # color scheme
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
      };
    };
  };
}
