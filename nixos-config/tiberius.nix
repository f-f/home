{ config, pkgs, ... }:

{
  # Boot config
  # See: https://discourse.nixos.org/t/nixos-on-mirrored-ssd-boot-swap-native-encrypted-zfs/9215/5
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.mirroredBoots = [
    { devices = ["nodev"]; path = "/boot"; }
    { devices = ["nodev"]; path = "/boot-fallback"; }
  ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  # This is for sensors to work
  boot.kernelModules = ["coretemp" "it87"];

  # ZFS config
  services.zfs = {
    autoSnapshot = {
      enable = true;
      monthly = 1; # keep only one monthly instead of 12
    };
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
  };

  networking.hostName = "tiberius";
  networking.firewall.enable = false;
  networking.hostId = "98546379";
  networking.enableIPv6 = false;
  networking.defaultGateway = {
    address = "192.168.8.1";
    interface = "enp2s0";
    metric = 10;
  };
  networking.dhcpcd.extraConfig =
  ''
    interface enp1s0
    metric 300

    interface enp2s0
    metric 200
  '';
  # TODO: investigate this if needed: https://askubuntu.com/questions/1134115/kvm-guest-cant-access-internet

  users.users.fabrizio.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6UcGI3prraCqsgl/A47zLxV15ZfAg0dDzB1C9b8RKC fabrizio+tiberius@caesar"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZLEPCkzxJwC5nEtDWyMatLnQYKVe/V2fbP/iIBeecj fabrizio+tiberius@augustus"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFbvK96xBIc8OH147+Kv7k/0DG1HeHSngD6Vcgx4OwW fabrizio+tiberius@claudius"
  ];

  systemd.services.duckdns= {
    description = "Ping DuckDNS";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "fabrizio";
      Group = "fabrizio";
      Environment = ''HEALTHCHECKS_TOKEN=${(import ./secrets.nix).healthchecksToken}'';
      Environment = ''DUCKDNS_TOKEN=${(import ./secrets.nix).duckdnsToken}'';
      ExecStart = "/home/fabrizio/bin/duckdns";
    };
    # path = with pkgs; [ bash curl ];
  };
  systemd.timers.duckdns = {
    description = "Ping DuckDNS";
    wantedBy = [ "timers.target" ];
    partOf = [ "duckdns.service" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "120min";
      Unit = "duckdns.service";
    };
  };
  # systemd.services.duckdns.enable = true;
  # systemd.timers.duckdns.enable = true;
}
