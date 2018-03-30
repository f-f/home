{ config, pkgs, ... }:

{
  imports = [
    ./server.nix
  ];

  # UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network and Firewall
  networking = {
    hostName = "put-hostname-here";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 10000 ];
    };
    
    # resolv.conf
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
}
