{
  config,
  inputs,
  ...
}: {

  age.rekey = {

    # store everything locally 
    storageMode = "local";
    # where rekeyed secrets will be stored
    localStorageDir = ../../secrets/${config.networking.hostName};
    # master identity - used to decrypt secrets in repository. Common to all hosts
    masterIdentities = [../../identity.age];
  };

}
