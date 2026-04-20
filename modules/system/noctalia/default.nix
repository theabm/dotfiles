{ pkgs, inputs, ... }:
{
  home-manager.users.andres = {
    imports = [ inputs.noctalia.homeModules.default ];
    programs.noctalia-shell = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./settings.json);
    };
  };
}
