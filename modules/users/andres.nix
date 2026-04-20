{ ... }:
{
  users.users.andres = {
    isNormalUser = true;
    description = "andres";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
