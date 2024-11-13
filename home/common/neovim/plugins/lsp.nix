{
  programs.nixvim.plugins = {
    # enable lsp format on save
    lsp-format = {
      enable = true;
      # lspServersToEnable = "all";
      lspServersToEnable = [
        "efm"
        "rust_analyzer"
        "lua_ls"
      ];
    };

    # Preconfigured config for efmls.
    # Enables formatters to act as lsp servers for nvim.
    efmls-configs = {
      enable = true;
      setup = {
        python.formatter = "black";
        nix.formatter = "alejandra";
      };
    };

    # configuration for nvim lsp
    lsp = {
      enable = true;
      inlayHints = true;
      keymaps = {
        silent = true;
        # keymaps for vim.diagnostic.<action>
        diagnostic = {
          "<leader>dn" = "goto_next";
          "<leader>do" = "open_float";
        };

        # keymaps for vim.lsp.buf.<action>
        lspBuf = {
          K = "hover";
          gd = "definition";
          gD = "declaration";
          gi = "implementation";
          gt = "type_definition";
          gr = "references";
          gs = "signature_help";
          "<leader>lr" = "rename";
          "<leader>la" = "code_action";
        };
      };

      # lsp server configurations
      servers = {
        # efm server
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
        clangd.enable = true;

        # lua lsp server
        lua_ls.enable = true;

        # nix language server
        nil_ls.enable = true;

        # haskell language server
        hls = {
          enable = true;
          installGhc = true;
        };

        # python ruff -- NOTE: this is different from ruff-lsp
        # which is the old server implementation written in python.
        # now, the lsp comes directly in the ruff binary and it is
        # written in rust so it is blazingly fast!
        ruff.enable = true;

        pyright.enable = true;

        # Rust language server
        # NOTE: At the moment, I include rustup in the system packages.
        # rustup takes care of installing cargo, rustc, and rust-analyzer
        # such that it is compatible with the version I select.
        # Therefore, I disable automatic installation for all of these.
        # TODO switch to declarative config
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          package = null;
        };

        # temporarily disabled -- breaking
        # pylsp = {
        #   enable = true;
        #   settings = {
        #     plugins = {
        #       jedi_completion.fuzzy = true;
        #
        #       pylsp_mypy.enabled = true;
        #
        #       # We don't need those as ruff-lsp is already providing such features.
        #       autopep8.enabled = false;
        #       flake8.enabled = false;
        #       mccabe.enabled = false;
        #       preload.enabled = false;
        #       pycodestyle.enabled = false;
        #       pydocstyle.enabled = false;
        #       pyflakes.enabled = false;
        #       pylint.enabled = false;
        #       ruff.enabled = false;
        #       yapf.enabled = false;
        #     };
        #   };
        # };
      };
    };
  };
}
