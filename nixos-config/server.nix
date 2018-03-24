{ config, pkgs, ... }:

{
  # Enable secured sshd
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    ports = [ 10000 ];
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };
}
