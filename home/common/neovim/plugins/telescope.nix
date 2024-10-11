{
  programs.nixvim.plugins = {
    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fm" = "marks";
        "<leader>qf" = "quickfix";
        "<leader>fd" = "diagnostics";
      };
    };
  };
}
