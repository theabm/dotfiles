{
  programs.nixvim.plugins = {
    # enable lsp format on save
    lsp-format = {
      enable = true;
      lspServersToEnable = "all";
    };
    # TODO: use conform

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

        #  NOTE: this is different from ruff-lsp which is written in python
        # python lsp
        ruff.enable = true;

        # python type checker
        pyright.enable = true;

        # NOTE: Use rust analyzer installed from Cargo
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          package = null;
        };
      };
    };
  };
}
