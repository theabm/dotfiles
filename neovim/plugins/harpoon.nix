{
programs.nixvim.plugins = {

      harpoon = {
        enable = true;
        keymaps = {
          addFile = "<leader>a";
          cmdToggleQuickMenu = "<leader>e";
          navFile = {
            "1" = "<C-H>";
            "2" = "<C-J>";
            "3" = "<C-K>";
            "4" = "<C-L>";
          };
        };
      };
};
}
