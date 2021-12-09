{ config, pkgs, ... }:

{
  # Boot config
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.loader.grub.mirroredBoots = [ { devices = ["nodev"]; path = "/boot"; } { devives = ["nodev"]; path = "/boot-fallback"; } ];
  boot.supportedFilesystems = [ "zfs" ]; 

  # See https://discourse.nixos.org/t/nixos-using-integrated-gpu-for-display-and-external-gpu-for-compute-a-guide/12345
  environment.systemPackages = [ pkgs.linuxPackages.nvidia_x11 ];
  boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
  boot.blacklistedKernelModules = [ "nouveau" "nvidia_drm" "nvidia_modeset" "nvidia" ];

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

  users.users.fabrizio.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6UcGI3prraCqsgl/A47zLxV15ZfAg0dDzB1C9b8RKC fabrizio+tiberius@caesar"
  ];
}
