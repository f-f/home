{ config, pkgs, ... }:

{
  # Enable secured sshd
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    ports = [ 10000 ];
    forwardX11 = true;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };
}
