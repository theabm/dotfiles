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

    # cyberdream colorscheme
    # colorschemes.cyberdream = {
    #   enable = true;
    #   settings = {
    #     transparent = true;
    #     italic_comments = true;
    #     hide_fillchars = true;
    #     borderless_telescope = false;
    #     terminal_colors = true;
    #   };
    # };
  };
}
