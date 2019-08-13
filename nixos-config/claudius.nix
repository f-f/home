{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./server.nix
  ];

  # Boot config
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];
  boot.supportedFilesystems = [ "zfs" ]; 
  boot.zfs = {
    extraPools = [ "storage" ];
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

  # videocard
  xserver.videoDrivers = [ "nvidia" ];

  networking.hostName = "claudius";  
  networking.firewall.enable = false;
  networking.hostId = "454f37c2";

  users.extraUsers.fabrizio.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtw3bhF1om3TmMQeaqVhkE6wKmVc39VVnqHMwQYmQtTsZRSU6+QyAQTr27PSUvHa2beac4qBnAcIUTsoLkS1BItNRRBAIujya8wuKxP3PlUXZr5UzokVb+zKYxF168ZzMtsWuxYZvo9NNf9HvymAL+1qSK1gOEzkgX6FbN74493f3naGdjoobCJ+FhGXn7DI9ABQ9WfEEP0zQ8SA8K9lfzbMn1x4Z1Uub9GbaQGJuiW5WAbA33uIPtBJ9Cxhej77V4DcLwXipFGH2Mhae1g9gF/1pP4FPfl7Y5vKJsbyFfR8neEisVYxJ60v3qe6xuAxn/COTJmV41bSnEjcCzQKOH+enqgNUDZwB6BPvNXoNuqucGi+InnDbr9LJUMKEc4N0VKPR+xewq1kbYHV5N2iASQqI9kkcrPwH8Gvjynd6BwVyQijHngMu3yqXKVf3RojIPAiQuaqhfmfwYOAlUrZLXo8nTpJZpZNKU9nmF9pkE5U04JcsgdLhqMBHrARWtzE9TMKHN1zicGu3LJZOmezlpv9Br0RVzMNtaeDvN4CpJja077eY0EoPzpiDEb4iroxkak49gDI2rORK3ZQWyGTfXLJ//OqXB0UZqO3dD2J3TzLPywWetAyK8N6WEaBkX0NIwF4aojDKhhi5ys8mqhI9s11eJQ75Rhd3oXywXvXMDVw== fabrizio@trajan"
  ];
}
