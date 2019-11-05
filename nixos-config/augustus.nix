{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./server.nix
  ];

  # UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network and Firewall
  networking = {
    hostName = "augustus";
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 10000 80 ];
    };
    interfaces.enp0s25.ipv4 = {
      addresses = [{
        address = "194.86.88.127";
        prefixLength = 24;
      }];
      routes = [
        #{ address = "194.86.88.0"; prefixLength = 24; options = { proto = "kernel"; scope = "link"; src = "194.86.88.127" }; }
        { address = "0.0.0.0"; prefixLength = 0; via = "194.86.88.1"; }
        { address = "10.13.37.0"; prefixLength = 24; via = "194.86.88.252"; }
      ];
    };

    defaultGateway = { address = "194.86.88.1"; interface = "enp0s25"; };

    # resolv.conf
    search = [
      "ksfmedia.lokal"
      "localdomain"
    ];
    nameservers = [
      "194.86.88.229"
      "193.229.0.40"
      "193.229.0.42" 
      "8.8.8.8"
    ];

    extraHosts = ''
      127.0.0.1 ksf.test
      127.0.0.1 hbl.ksf.test
      127.0.0.1 on.ksf.test
      127.0.0.1 vn.ksf.test
      127.0.0.1 api.ksf.test
    '';
  };
  
  services = {
    # videocard
    xserver.videoDrivers = [ "nvidia" ];

    gitlab-runner = {
      enable = true;
      configOptions = {
        concurrent = 4;
        runners = [{
          name = "nilrecurring";
          url = "https://git.ksfmedia.fi/";
          token = (import ./secrets.nix).token;
          executor = "docker";
          # package = pkgs.unstable.gitlab-runner;
          docker = {
            image = "docker:latest";
            privileged = false;
            disable_cache = false;
            volumes = [ "/var/run/docker.sock:/var/run/docker.sock" "/cache" ];
          };
        }];
      };
    };
  };

  
  users.extraUsers.fabrizio.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtw3bhF1om3TmMQeaqVhkE6wKmVc39VVnqHMwQYmQtTsZRSU6+QyAQTr27PSUvHa2beac4qBnAcIUTsoLkS1BItNRRBAIujya8wuKxP3PlUXZr5UzokVb+zKYxF168ZzMtsWuxYZvo9NNf9HvymAL+1qSK1gOEzkgX6FbN74493f3naGdjoobCJ+FhGXn7DI9ABQ9WfEEP0zQ8SA8K9lfzbMn1x4Z1Uub9GbaQGJuiW5WAbA33uIPtBJ9Cxhej77V4DcLwXipFGH2Mhae1g9gF/1pP4FPfl7Y5vKJsbyFfR8neEisVYxJ60v3qe6xuAxn/COTJmV41bSnEjcCzQKOH+enqgNUDZwB6BPvNXoNuqucGi+InnDbr9LJUMKEc4N0VKPR+xewq1kbYHV5N2iASQqI9kkcrPwH8Gvjynd6BwVyQijHngMu3yqXKVf3RojIPAiQuaqhfmfwYOAlUrZLXo8nTpJZpZNKU9nmF9pkE5U04JcsgdLhqMBHrARWtzE9TMKHN1zicGu3LJZOmezlpv9Br0RVzMNtaeDvN4CpJja077eY0EoPzpiDEb4iroxkak49gDI2rORK3ZQWyGTfXLJ//OqXB0UZqO3dD2J3TzLPywWetAyK8N6WEaBkX0NIwF4aojDKhhi5ys8mqhI9s11eJQ75Rhd3oXywXvXMDVw== fabrizio@trajan"
  ];
}
