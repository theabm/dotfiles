{
  programs.nixvim = {
    files."after/ftplugin/norg.lua".localOpts = {
      conceallevel = 1;
    };

    plugins = {
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
    };
  };
}
