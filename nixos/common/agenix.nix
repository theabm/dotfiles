{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  age.rekey = {
    storageMode = "local";
    masterIdentities = [../../identity.age];
    localStorageDir = ../../secrets/${config.networking.hostName};
  };

  # enable ssh server for agenix configuration.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
}
