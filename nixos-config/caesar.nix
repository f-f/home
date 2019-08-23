{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./server.nix
    /home/fabrizio/musnix
  ];

  musnix.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Network and Firewall
  networking = {
    hostName = "caesar";

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
