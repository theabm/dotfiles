{
  programs.nixvim = {
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

    plugins = {
      # sources
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-path.enable = true;

      # setup
      cmp = {
        enable = true;
        autoEnableSources = false;

        settings = {
          mapping = {
            "<C-B>" = "cmp.mapping.scroll_docs(-4)";
            "<C-F>" = "cmp.mapping.scroll_docs(4)";
            "<C-N>" = "cmp.mapping.select_next_item()";
            "<C-P>" = "cmp.mapping.select_prev_item()";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-E>" = "cmp.mapping.abort()";
            "<C-Y>" = "cmp.mapping.confirm({ select = true })";
          };
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
          sources = {
            __raw = ''
                cmp.config.sources({
              {name = "nvim_lsp"},
              {name = "luasnip"},
              {name = "nvim_lua"},
              {name = "path"},
              {
                name = "buffer",
                option = {
                    get_bufnrs = function() return vim.api.nvim_list_bufs() end
                },
              },
              {name = "neorg"},
                })
            '';
          };
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

          experimental = {
            "ghost_text" = true;
          };
          window.documentation.__raw = "cmp.config.window.bordered()";
          window.completion.__raw = "cmp.config.window.bordered()";
        };
      };
    };
  };
}
