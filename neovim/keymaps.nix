{
  programs.nixvim = {
    # keymappings
    globals = {
      mapleader = " ";
      maplocalleader = "_";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>pv";
        action = "vim.cmd.Ex";
        lua = true;
      }
      {
        mode = "n";
        key = "Y";
        action = "y$";
      }
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }
      {
        mode = "n";
        key = "<M-j>";
        action = ":move+<CR>";
      }
      {
        mode = "n";
        key = "<M-k>";
        action = ":move-2<CR>";
      }
      {
        mode = "v";
        key = "<TAB>";
        action = ">gv";
      }
      {
        mode = "v";
        key = "<S-TAB>";
        action = "<gv";
      }
      {
        mode = "n";
        key = "J";
        action = "mzJ`z";
      }
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
      }
      {
        mode = "n";
        key = "H";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "L";
        action = "<C-w>l";
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = ":resize -2<CR>";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = ":resize +2<CR>";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = ":vertical resize -2<CR>";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = ":vertical resize +2<CR>";
      }
      {
        mode = "x";
        key = "<leader>p";
        action = "[[\"_dP]]";
        lua = true;
      }
      {
        mode = ["n" "v"];
        key = "<leader>y";
        action = "[[\"+y]]";
        lua = true;
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = "[[\"+Y]]";
        lua = true;
      }
      {
        mode = ["n" "v"];
        key = "<leader>d";
        action = "[[\"_d]]";
        lua = true;
      }
      {
        mode = "n";
        key = "Q";
        action = "<nop>";
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "vim.lsp.buf.format";
        lua = true;
      }
      {
        mode = "n";
        key = "<leader>s";
        action = "[[:%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>]]";
        lua = true;
      }
      {
        mode = "n";
        key = "<C-g>";
        action = ":TagbarToggle<cr>";
        options.silent = true;
      }
    ];
  };
}
