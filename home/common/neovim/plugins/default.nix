{
  imports = [
    ./completion.nix
    ./lsp.nix
    ./harpoon.nix
    ./telescope.nix
    ./neorg.nix
    # ./hardtime.nix
    ./treesitter.nix
  ];

  programs.nixvim.plugins = {
    indent-blankline.enable = true;
    markdown-preview.enable = true;
    nvim-autopairs.enable = true;
    web-devicons.enable = true;

    colorizer.enable = true;

    treesitter-context = {
      enable = true;
      settings.enable = true;
    };

    luasnip.enable = true;
    comment.enable = true;
    gitsigns.enable = true;
    lualine.enable = true;
    tagbar.enable = true;
    leap.enable = true;
    oil = {
      enable = true;
      settings = {
        skip_confirm_for_simple_edits = true;
        prompt_save_on_select_new_entry = false;
        watch_for_changes = true;
        view_options = {
          show_hidden = true;
          natural_order = false;
        };
      };
    };
    vim-surround.enable = true;
  };
}
