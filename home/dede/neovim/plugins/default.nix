{
  imports = [
    ./completion.nix
    ./lsp.nix
    ./harpoon.nix
    ./telescope.nix
    ./neorg.nix
    ./hardtime.nix
    ./treesitter.nix
  ];

  programs.nixvim.plugins = {
    indent-blankline.enable = true;
    markdown-preview.enable = true;
    nvim-autopairs.enable = true;

    luasnip.enable = true;
    comment.enable = true;
    gitsigns.enable = true;
    lualine.enable = true;
    tagbar.enable = true;
    leap.enable = true;
  };
}
