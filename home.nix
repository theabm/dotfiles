{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "andres";
  home.homeDirectory = "/home/andres";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # technically I dont need this since nixvim should take care of this.
  programs.ruff = {
    enable = true;
    settings = {
      line-length = 100;
    };
  };

  home.packages = with pkgs; [
    black
  ];

  # nixvim
  home.shellAliases.v = "nvim";

  programs.nixvim = {
    wrapRc = true;
    extraConfigLua = ''
        cmp_kinds = {
            Text = '  ',
            Method = '  ',
            Function = '  ',
            Constructor = '  ',
            Field = '  ',
            Variable = '  ',
            Class = '  ',
            Interface = '  ',
            Module = '  ',
            Property = '  ',
            Unit = '  ',
            Value = '  ',
            Enum = '  ',
            Keyword = '  ',
            Snippet = '  ',
            Color = '  ',
            File = '  ',
            Reference = '  ',
            Folder = '  ',
            EnumMember = '  ',
            Constant = '  ',
            Struct = '  ',
            Event = '  ',
            Operator = '  ',
            TypeParameter = '  ',
      }
    '';

    clipboard.providers.wl-copy.enable = true;

    enable = true;

    # color scheme
    colorschemes.tokyonight = {
      enable = true;
      style = "night";
    };

    # options
    options = {
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
        mode = "n";
        key = "m";
        action = ":w<CR>";
      }
      {
        mode = "n";
        key = "t";
        action = ":q<CR>";
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

    files."after/ftplugin/norg.lua".localOptions = {
      conceallevel = 1;
    };

    # plugins
    plugins = {
      hardtime = {
        enable = true;
        allowDifferentKey = true;
        maxCount = 1;
        extraOptions = {
          hardtime_motion_with_count_resets = 1;
        };
      };
      indent-blankline.enable = true;
      markdown-preview.enable = true;
      nvim-autopairs.enable = true;
      neorg = {
        enable = true;
        modules = {
          "core.defaults".__empty = null;
          "core.concealer" = {
            config = {
              icon_preset = "diamond";
            };
          };
          "core.dirman" = {
            config = {
              workspaces = {
                notes = "~/notes";
                on_the_way_to_10k = "~/on_the_way_to_10k";
              };
              default_workspace = "on_the_way_to_10k";
            };
          };
          "core.summary".__empty = null;
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };
      treesitter = {
        enable = true;
        nixvimInjections = true;
        folding = true;
        indent = true;
      };

      luasnip.enable = true;
      comment-nvim.enable = true;
      gitsigns.enable = true;
      lualine.enable = true;
      tagbar.enable = true;

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

      leap.enable = true;

      lsp-format = {
        enable = true;
        lspServersToEnable = [
          "efm"
          "rust-analyzer"
          "lua-ls"
        ];
      };

      efmls-configs = {
        enable = true;
        setup.python.formatter = "black";
        setup.nix.formatter = "alejandra";
      };

      lsp = {
        enable = true;
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<leader>rn" = "rename";
          };
        };

        servers = {
          efm = {
            enable = true;
            extraOptions.init_options = {
              documentFormatting = true;
              documentRangeFormatting = true;
              hover = true;
              documentSymbol = true;
              codeAction = true;
              completion = true;
            };
          };
          lua-ls.enable = true;
          nil_ls.enable = true;

          hls = {
            enable = true;
            package = null;
          };

          ruff-lsp.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            package = null;
          };

          pylsp = {
            enable = true;
            settings = {
              plugins = {
                jedi_completion.fuzzy = true;

                pylsp_mypy.enabled = true;

                # We don't need those as ruff-lsp is already providing such features.
                autopep8.enabled = false;
                flake8.enabled = false;
                mccabe.enabled = false;
                preload.enabled = false;
                pycodestyle.enabled = false;
                pydocstyle.enabled = false;
                pyflakes.enabled = false;
                pylint.enabled = false;
                ruff.enabled = false;
                yapf.enabled = false;
              };
            };
          };
        };
      };

      nvim-cmp = {
        formatting.format = ''
          function(entry, vim_item)
              -- concatenate the symbol for the completion along with
              -- the kind of the completion for example:  class_name
              vim_item.kind = (cmp_kinds[vim_item.kind] or ''') .. vim_item.kind
              -- show the source of the completion i.e. if it comes from
              -- LSP or the Buffer or LuaSnip etc.
              -- This is useful for me to make sure I am selecting what
              -- I want.
              vim_item.menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  nvim_lua = "[Lua]",
                  latex_symbols = "[LaTeX]",
                  path = "[Path]",
                  cmdline = "[Cmd]"
              })[entry.source.name]
              return vim_item
          end
        '';

        enable = true;

        snippet.expand = "luasnip";

        mapping = {
          "<C-B>" = "cmp.mapping.scroll_docs(-4)";
          "<C-F>" = "cmp.mapping.scroll_docs(4)";
          "<C-N>" = "cmp.mapping.select_next_item()";
          "<C-P>" = "cmp.mapping.select_prev_item()";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-E>" = "cmp.mapping.abort()";
          "<C-Y>" = "cmp.mapping.confirm({ select = true })";
        };

        experimental.ghost_text = true;

        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "nvim_lua";}
          {name = "path";}
          {
            name = "buffer";
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
          {name = "neorg";}
        ];
        # window.documentation.__raw = "cmp.config.window.bordered()";
        # window.completion.__raw = "cmp.config.window.bordered()";
      };
    };
  };
}
