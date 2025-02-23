{
  programs.nixvim.plugins = {
    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fm" = "marks";
        "<leader>fq" = "quickfix";
        "<leader>fd" = "diagnostics";
        "<leader>fl" = "current_buffer_fuzzy_find";
      };
      settings.pickers = {
        "find_files" = {
          hidden = true;
        };
      };
    };
  };
}
