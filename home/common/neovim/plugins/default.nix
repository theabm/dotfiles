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
    # indentation line guide
    indent-blankline.enable = true;
    # preview markdown from nvim
    markdown-preview.enable = true;
    # automatically create pairs () {} ..
    nvim-autopairs.enable = true;
    # provide nerd icons for plugins
    web-devicons.enable = true;

    # show color for color codes #FFFF00
    colorizer.enable = true;

    # show context (for example, for long functions, it shows which function you 
    # are inspecting)
    treesitter-context = {
      enable = true;
      settings.enable = true;
    };

    # luasnippets
    luasnip.enable = true;
    # commenting with ease
    comment.enable = true;
    # git signs for viewing changes 
    gitsigns.enable = true;
    # lua status line at the bottom 
    lualine.enable = true;
    # show general structure of file (functions, classes, etc) in a side menu :TagbarToggle
    tagbar.enable = true;
    # get to where you want to edit in a few keystrokes
    leap.enable = true;
    # edit file directory like a normal vim buffer
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
    # quickly surround 
    vim-surround.enable = true;
  };
}
