{ config, pkgs, lib, modulesPath, ... }:

let secrets = "/home/fabrizio/nixos-config/secrets.sh";
    mkFolder = { path, devices, ...}:
      {
        path = path;
        devices = devices;
        ignorePerms = false;
        versioning = {
          type = "staggered";
          params = {
            cleanInterval = "3600"; # 1 hour in seconds
            maxAge = "15552000"; # 180 days in seconds
          };
        };
      };
in
{
  # Hardware config
  imports =
    [ (modulePath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
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

  # ZFS stuff
  boot.supportedFilesystems = [ "zfs" ];
  # boot.zfs = {
  #   extraPools = [ "tank" ];
  # };
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # ZFS config
  # services.zfs = {
  #   autoSnapshot = {
  #     enable = true;
  #     monthly = 1; # keep only one monthly instead of 12
  #   };
  #   autoScrub = {
  #     enable = true;
  #     # Run on the first Monday of the month
  #     # Use `systemd-analyze calendar $INTERVAL` to validate correctness
  #     interval = "Mon *-*-1..7 06:00:00";
  #   };
  #   trim = {
  #     enable = true;
  #     interval = "Fri *-*-* 11:11:11";
  #   };
  #   zed.settings = {
  #     ZED_EMAIL_ADDR = [ "root" ];
  #     ZED_EMAIL_PROG = zfsNotifyCmd.outPath;
  #     ZED_NOTIFY_VERBOSE = true;
  #     ZED_SCRUB_AFTER_RESILVER = true;
  #   };
  # };

  # VPN
  services.tailscale.enable = true;

  # Virtualisation
  security.polkit.enable = true;

  # Networking
  networking.hostName = "domitian";
  networking.enableIPv6 = false;
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
  networking.firewall.enable = false;

  users.users.fabrizio.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWBoYJ6BAQevcLwudr4yQCV6qdyMTrW8EYd/FZsD2/O fabrizio+claudius@tiberius"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtNeH9zrRkxq+Be1PbdyvVhUcNIVVrLijeN/ct3HnhQ4W1qq8ixFyfUEiwCSsZvR4L1L/GVZZmwmi7TRqRsOVVfV54q7QAzTKgs6+tPZLDktsvORiNoPu1uONH8Lf8Cbvpdnx6fCl+z8VU2p5+myAF4FXVY4EX2m6TCKJnwdRuZsjZh98XveUf46vXFjMqNUIW9ueipCCoDAyIqX8V3TmjWgyHZ3rIxGExnXNFYPN4Wz4UNRYI2Da1DOtFqXgFpm+nxVqk6QziRnUpgIXkBL9QBPnJEfKywy7rHpQlDX6/f2imFjkNAZq5my22KSoeYTJZyAuCrCCHgpY/ljl8kbL5ZWvPCai7DYpTVRnqhQAey7FUaafMPC/pmD6QYrb566QEYgj1MNknPMnvEPSR2xFJAiCo95Ckz9OvRCMZ1MA/wmRDOtL5dxqJWjnDtbXFt2jy4zLfrPKYKua/K5GOPHwMIMMDGGkJriWTkmi4OqZK2yPyFyfIVHJOhZhl5OtyQTsRyTDK4tPPZ3h/G8Q2YvvK6rTSO3oJbCn8yYqoPe8rAlrmeOBhB89/s9fqiczCHNt2Yj2Lax+aARF3lasA4pmbAseIO+jgYsk8xHhytTE45rLQnSYz63YuycJXJFKIgyqIQxZ1Jxj2GbzzoWeRUFxCKW9qmMcx+QP22BTIvE5HuQ== fabrizio@caesar"
  ];
}
