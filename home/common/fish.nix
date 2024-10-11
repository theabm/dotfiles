{
  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];
  # Settings for fish shell
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        v = "nvim";
        c = "z";
        za = "zathura";
        y = "yazi";
        gl = ''
          git log --branches --remotes --tags --graph --pretty='%C(yellow)%h
                    %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --date=relative
        '';
        s = ''TERM=xterm-256color ssh'';
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
