{
  config,
  pkgs,
  lib,
  ...
}: let
  dotfiles = "/home/andres/dotfiles";
  user = "andres";
  group = "users";

  outOfStoreSymlink = target: source:
    "L+ ${target} - ${user} ${group} - ${source}";
in {
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        v = "nvim";
        vim = "nvim";
        c = "z";
        za = "zathura";
        y = "yazi";
        gl = ''
          git log --branches --remotes --tags --graph --pretty='%C(yellow)%h
                    %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --date=relative
        '';
        s = "TERM=xterm-256color ssh";
      };
      interactiveShellInit = ''
        set fish_greeting
        set -g fish_key_bindings fish_vi_key_bindings

        fish_add_path --global --path \
          $HOME/.config/emacs/bin \
          $HOME/.cargo/bin

        ${lib.getExe pkgs.starship} init fish | source
        ${lib.getExe pkgs.zoxide} init fish | source
        ${pkgs.fzf}/bin/fzf --fish | source
      '';
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    gnupg.agent.enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    eza
    fzf
    lazygit
    ripgrep
    starship
    yazi
    zoxide
  ];

  systemd.tmpfiles.rules = [
    "d /home/andres/.config/kitty 0755 ${user} ${group} -"
    (outOfStoreSymlink "/home/andres/.config/kitty/kitty.conf" "${dotfiles}/home/common/kitty/kitty.conf")
  ];
}
