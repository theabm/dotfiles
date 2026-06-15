{
  pkgs,
  inputs,
  ...
}: let
  dotfiles = "/home/andres/dotfiles";
  noctaliaPackage =
    inputs.noctalia.packages.${pkgs.system}.default
    or inputs.noctalia.packages.${pkgs.system}.noctalia-shell;
in {
  environment.systemPackages = [
    noctaliaPackage
  ];

  systemd.tmpfiles.rules = [
    "d /home/andres/.config/noctalia 0755 andres users -"
    "L+ /home/andres/.config/noctalia/settings.json - andres users - ${dotfiles}/modules/system/noctalia/settings.json"
  ];

  systemd.user.services.nm-applet = {
    description = "NetworkManager applet and secret agent";
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      Restart = "on-failure";
    };
  };
}
