{
  # Settings for fish shell 
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        v = "nvim";
        #cd = "z";
        za = "zathura";
      };
      interactiveShellInit = ''
        # Commands to run in interactive sessions can go here
        set fish_greeting
        set -g fish_key_bindings fish_vi_key_bindings
      '';
    };

    # terminal programs 
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
