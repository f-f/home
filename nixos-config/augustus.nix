{ config, pkgs, lib, modulesPath, ... }:

let secrets = "/home/fabrizio/nixos-config/secrets.sh";

in
{
  # Hardware config
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "coretemp" "it87" "nct6775" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9ead2a01-0c0b-48c4-b88f-171cd4c7ac63";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AFA2-E8E2";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  networking.useDHCP = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  # Boot config
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # VPN
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraSetFlags = ["--advertise-exit-node"];
  };

  # Virtualisation
  security.polkit.enable = true;

  # Networking
  networking.hostName = "augustus";
  networking.hostId = "114f37c7";
  networking.enableIPv6 = false;
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
  networking.firewall.enable = false;

  # See https://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration
  systemd.services.tailscale-network-opt = {
    description = "tailscale network optimisation for exit nodes";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "${pkgs.ethtool}/bin/ethtool -K `${pkgs.iproute2}/bin/ip -o route get 8.8.8.8 | cut -f 5 -d ' '` rx-udp-gro-forwarding on rx-gro-list off"
      '';
    };
    wantedBy = [ "network-pre.target" ];
  };

  users.users.fabrizio.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDVCfpP3ViN5RB7EU4B8DFDsoh77uJY4rAXu2BbQjHg fabrizio+augustus@aurelius"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ixQn4AbqtDzlGTKAGP5kE0EAUBox1rKxmy080rnF9 fabrizio+augustus@tiberius"
  ];
}
