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
        # action.__raw = "vim.cmd.Ex";
        action = ":Oil .<CR>";
      }
      {
        mode = "n";
        key = "<leader>pp";
        action = "<CMD>Oil<CR>";
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
      # Use Shift p instead to achieve same effect.
      # Avoid pasting over a word to overwrite the 
      # yank register
      # {
      #   mode = "x";
      #   key = "<leader>p";
      #   action.__raw = "[[\"_dP]]";
      # }
      {
        mode = ["n" "v"];
        key = "<leader>y";
        action.__raw = "[[\"+y]]";
      }
      {
        mode = "n";
        key = "<leader>Y";
        action.__raw = "[[\"+Y]]";
      }
      {
        mode = "n";
        key = "Q";
        action = "<nop>";
      }
      # Not working
      {
        mode = "n";
        key = "<leader>fc";
        action.__raw = "vim.lsp.buf.format";
      }
      {
        mode = "n";
        key = "<leader>s";
        action.__raw = "[[:%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>]]";
      }
    ];
  };
}
