{
  programs.nixvim = {
    opts = {
      # show numbers
      number = true;
      relativenumber = true;

      swapfile = false;
      backup = false;
      undodir.__raw = ''os.getenv("HOME") .. "/.vim/undodir"'';
      undofile = true;

      # new tabs open right or below by default
      splitright = true;
      splitbelow = true;

      # show cursorline
      cursorline = true;

      # tab behavior
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      autoindent = true;

      virtualedit = "block";

      wrap = false;

      hlsearch = false;

      incsearch = true;
      inccommand = "split";

      termguicolors = true;
      scrolloff = 999;
      signcolumn = "yes";
      colorcolumn = "80";

      conceallevel = 2;
      concealcursor = "c";

      updatetime = 100;

      foldlevel = 99;
    };
  };
}
