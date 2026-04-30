{
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.andres = {
    imports = [inputs.noctalia.homeModules.default];
    programs.noctalia-shell = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./settings.json);
    };

    systemd.user.services.nm-applet = {
      Unit = {
        Description = "NetworkManager applet and secret agent";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
        Restart = "on-failure";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
