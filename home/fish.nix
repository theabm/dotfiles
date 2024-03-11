{
  # Settings for fish shell and all the terminal packages I use
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        v = "nvim";
        #cd = "z";
        #z = "zathura";
      };
      interactiveShellInit = ''
        # Commands to run in interactive sessions can go here
        set fish_greeting
        set -g fish_key_bindings fish_vi_key_bindings
      '';
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    btop.enable = true;

    yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    ripgrep.enable = true;
  };
}
