{
  imports = [
    ./completion.nix
    ./lsp.nix
    ./telescope.nix
    ./neorg.nix
    # ./hardtime.nix
    ./treesitter.nix
  ];

  programs.nixvim.plugins = {
    # dim inactive parts of code
    twilight.enable = true;
    # highlight todo, 
    todo-comments.enable = true;
    # use instead of tagbar
    trouble.enable = true;
    # use yazi
    yazi.enable = true;
    # which key
    which-key.enable = true;
    # indentation line guide
    indent-blankline.enable = true;
    # preview markdown from nvim
    # markdown-preview.enable = true;
    # automatically create pairs () {} ..
    nvim-autopairs.enable = true;
    # provide nerd icons for plugins
    web-devicons.enable = true;
    # show color for color codes #FFFF00
    colorizer.enable = true;
    # show context (for example, for long functions, it shows which function you 
    # are inspecting)
    treesitter-context.enable = true;
    treesitter-refactor.enable = true;
    # luasnippets
    # luasnip.enable = true;
    # commenting with ease
    comment.enable = true;
    # git signs for viewing changes 
    gitsigns.enable = true;
    # lua status line at the bottom 
    lualine.enable = true;
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
  };
}
