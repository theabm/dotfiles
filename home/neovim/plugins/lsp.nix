{
  programs.nixvim.plugins = {
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
  };
}
