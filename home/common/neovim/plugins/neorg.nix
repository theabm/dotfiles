{
  programs.nixvim = {
    files."after/ftplugin/norg.lua" = {
    localOpts = {
      # needed to hide @code @end tags
      conceallevel = 3;
    };
    opts = {
      # consistency with initial setup before changing to 100
      colorcolumn = "80";
    };
    };

    plugins = {
      neorg = {
        enable = true;
        modules = {
          "core.defaults".__empty = null;

          "core.concealer" = {
            config = {
              icon_preset = "diamond";
              icons = {
                code_block = {
                # If true will only dim the content of the code block (without the @code and @end 
                # lines), not the entirety of the code block itself.
                  content_only = true;
                  # How wide the code block should be (default: "fullwidth")
                  width = "content";
                  # conceal @code and @end
                  conceal = true;
                  # padding of dimmed code block 
                  padding = {
                    left = 0;
                    # increase right padding for "nicer" look
                    right = 5;
                  };
                  # make the dimming the same style as your cursorline.
                  highlight = "CursorLine";
                };
                # make the horizontal delimiter line the same length as 
                # neovims textwidth
                delimiter.horizontal_line.right = "textwidth";
              };
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

          "core.integrations.nvim-cmp".__empty = null;
        };
      };
    };
  };
}
