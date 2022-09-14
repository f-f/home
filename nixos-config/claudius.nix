{ config, pkgs, ... }:

let secrets = import ./secrets.nix;
in
{
  # Boot config
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This is for sensors to work
  boot.kernelModules = ["coretemp" "it87" "nct6775"];

  # Activate the serial
  boot.kernelParams = ["console=tty0" "console=ttyS0,115200"];

  # ZFS stuff
  boot.supportedFilesystems = [ "zfs" ]; 
  boot.zfs = {
   extraPools = [ "tank" ];
  };

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

  networking.hostName = "claudius";  
  networking.firewall.enable = false;
  networking.hostId = "454f37c2";
  networking.enableIPv6 = false;
  networking.defaultGateway = {
    address = "192.168.8.1";
    interface = "enp7s0";
    metric = 10;
  };
  networking.dhcpcd.extraConfig =
  ''
    interface enp9s0f0
    metric 300

    interface enp9s0f1
    metric 290

    interface enp7s0
    metric 200
  '';

  users.users.fabrizio.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJXBRSjddrsra0BsB3ud5VfinFPh8rtWLmsmisajfWKOZaUf9YCUzzF6e92GqSB/sjWvuDHkmgKriU/JQCVi9O0= claudius@secretive.hadrian.local"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtw3bhF1om3TmMQeaqVhkE6wKmVc39VVnqHMwQYmQtTsZRSU6+QyAQTr27PSUvHa2beac4qBnAcIUTsoLkS1BItNRRBAIujya8wuKxP3PlUXZr5UzokVb+zKYxF168ZzMtsWuxYZvo9NNf9HvymAL+1qSK1gOEzkgX6FbN74493f3naGdjoobCJ+FhGXn7DI9ABQ9WfEEP0zQ8SA8K9lfzbMn1x4Z1Uub9GbaQGJuiW5WAbA33uIPtBJ9Cxhej77V4DcLwXipFGH2Mhae1g9gF/1pP4FPfl7Y5vKJsbyFfR8neEisVYxJ60v3qe6xuAxn/COTJmV41bSnEjcCzQKOH+enqgNUDZwB6BPvNXoNuqucGi+InnDbr9LJUMKEc4N0VKPR+xewq1kbYHV5N2iASQqI9kkcrPwH8Gvjynd6BwVyQijHngMu3yqXKVf3RojIPAiQuaqhfmfwYOAlUrZLXo8nTpJZpZNKU9nmF9pkE5U04JcsgdLhqMBHrARWtzE9TMKHN1zicGu3LJZOmezlpv9Br0RVzMNtaeDvN4CpJja077eY0EoPzpiDEb4iroxkak49gDI2rORK3ZQWyGTfXLJ//OqXB0UZqO3dD2J3TzLPywWetAyK8N6WEaBkX0NIwF4aojDKhhi5ys8mqhI9s11eJQ75Rhd3oXywXvXMDVw== fabrizio@trajan"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtNeH9zrRkxq+Be1PbdyvVhUcNIVVrLijeN/ct3HnhQ4W1qq8ixFyfUEiwCSsZvR4L1L/GVZZmwmi7TRqRsOVVfV54q7QAzTKgs6+tPZLDktsvORiNoPu1uONH8Lf8Cbvpdnx6fCl+z8VU2p5+myAF4FXVY4EX2m6TCKJnwdRuZsjZh98XveUf46vXFjMqNUIW9ueipCCoDAyIqX8V3TmjWgyHZ3rIxGExnXNFYPN4Wz4UNRYI2Da1DOtFqXgFpm+nxVqk6QziRnUpgIXkBL9QBPnJEfKywy7rHpQlDX6/f2imFjkNAZq5my22KSoeYTJZyAuCrCCHgpY/ljl8kbL5ZWvPCai7DYpTVRnqhQAey7FUaafMPC/pmD6QYrb566QEYgj1MNknPMnvEPSR2xFJAiCo95Ckz9OvRCMZ1MA/wmRDOtL5dxqJWjnDtbXFt2jy4zLfrPKYKua/K5GOPHwMIMMDGGkJriWTkmi4OqZK2yPyFyfIVHJOhZhl5OtyQTsRyTDK4tPPZ3h/G8Q2YvvK6rTSO3oJbCn8yYqoPe8rAlrmeOBhB89/s9fqiczCHNt2Yj2Lax+aARF3lasA4pmbAseIO+jgYsk8xHhytTE45rLQnSYz63YuycJXJFKIgyqIQxZ1Jxj2GbzzoWeRUFxCKW9qmMcx+QP22BTIvE5HuQ== fabrizio@caesar"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtNeH9zrRkxq+Be1PbdyvVhUcNIVVrLijeN/ct3HnhQ4W1qq8ixFyfUEiwCSsZvR4L1L/GVZZmwmi7TRqRsOVVfV54q7QAzTKgs6+tPZLDktsvORiNoPu1uONH8Lf8Cbvpdnx6fCl+z8VU2p5+myAF4FXVY4EX2m6TCKJnwdRuZsjZh98XveUf46vXFjMqNUIW9ueipCCoDAyIqX8V3TmjWgyHZ3rIxGExnXNFYPN4Wz4UNRYI2Da1DOtFqXgFpm+nxVqk6QziRnUpgIXkBL9QBPnJEfKywy7rHpQlDX6/f2imFjkNAZq5my22KSoeYTJZyAuCrCCHgpY/ljl8kbL5ZWvPCai7DYpTVRnqhQAey7FUaafMPC/pmD6QYrb566QEYgj1MNknPMnvEPSR2xFJAiCo95Ckz9OvRCMZ1MA/wmRDOtL5dxqJWjnDtbXFt2jy4zLfrPKYKua/K5GOPHwMIMMDGGkJriWTkmi4OqZK2yPyFyfIVHJOhZhl5OtyQTsRyTDK4tPPZ3h/G8Q2YvvK6rTSO3oJbCn8yYqoPe8rAlrmeOBhB89/s9fqiczCHNt2Yj2Lax+aARF3lasA4pmbAseIO+jgYsk8xHhytTE45rLQnSYz63YuycJXJFKIgyqIQxZ1Jxj2GbzzoWeRUFxCKW9qmMcx+QP22BTIvE5HuQ== fabrizio@augustus"
  ];

  systemd.services.duckdns= {
    enable = true;
    description = "Ping DuckDNS";
    after = [ "network.target" ];
    path = with pkgs; [ bash curl ];
    environment = {
      HEALTHCHECKS_TOKEN = secrets.healthchecksToken;
      DUCKDNS_TOKEN = secrets.duckdnsToken;
    };
    serviceConfig = {
      Type = "oneshot";
      User = "fabrizio";
      Group = "fabrizio";
      ExecStart = "/home/fabrizio/bin/duckdns";
    };
  };
  systemd.timers.duckdns = {
    enable = true;
    description = "Ping DuckDNS";
    wantedBy = [ "timers.target" ];
    partOf = [ "duckdns.service" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "20min";
      Unit = "duckdns.service";
    };
  };
}
