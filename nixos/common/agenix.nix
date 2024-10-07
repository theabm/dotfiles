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
    # store everything locally
    storageMode = "local";
    # my master identity - used to decrypt secrets in repository.
    masterIdentities = [../../identity.age];
    localStorageDir = ../../secrets/${config.networking.hostName};
  };

  # enable ssh server for agenix configuration.
  # This is the public-private key pair I will use to decrypt secrets at build time.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
}
