{ config, pkgs, lib, modulesPath, ... }:

let secrets = "/home/fabrizio/nixos-config/secrets.sh";

in
{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "nvidia" "coretemp" "k10temp" ];
  boot.extraModulePackages = [ ];
  boot.loader = {
    timeout = 10;
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      # efiInstallAsRemovable = true;
      devices = [ "nodev" ];
      useOSProber = true;
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/78227e20-16c0-4c66-be47-9067636eb468";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C820-6406";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.cudaSupport = true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.nvidiaPersistenced = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

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
  networking.hostId = "111f37c7";
  networking.enableIPv6 = false;
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
  networking.firewall.enable = false;
  networking.useDHCP = true;

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

  # ds4 inference server
  systemd.services.ds4-server = {
    description = "ds4 inference server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      DS4_CUDA_COPY_MODEL = "1";
    };
    serviceConfig = {
      Type = "simple";
      User = "fabrizio";
      Group = "fabrizio";
      WorkingDirectory = "/home/fabrizio/code/ds4";
      ExecStart = "/home/fabrizio/code/ds4/ds4-server --ctx 200000 --kv-disk-dir /tmp/ds4-kv --kv-disk-space-mb 8192 --host 0.0.0.0";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  users.users.fabrizio.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDVCfpP3ViN5RB7EU4B8DFDsoh77uJY4rAXu2BbQjHg fabrizio+augustus@aurelius"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ixQn4AbqtDzlGTKAGP5kE0EAUBox1rKxmy080rnF9 fabrizio+augustus@tiberius"
  ];
  
  system.stateVersion = "25.11";
}
