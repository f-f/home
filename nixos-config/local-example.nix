{ config, pkgs, ... }:

{
  imports = [
    ./server.nix
  ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Network and Firewall
  networking = {
    hostName = "put-hostname-here";

    firewall = {
      enable = true;
      allowedTCPPorts = [ 10000 ];
    };

    useDHCP = false;
    interfaces.ens45.ipv4 = {
      addresses = [{
        address = "64.42.64.42";
        prefixLength = 24;
      }];
      routes = [
        # Default route
        { prefixLength = 0; address = "0.0.0.0"; via = "64.42.64.1"; }
      ];
    };

    # resolv.conf
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
}
