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
  # build CUDA kernels only for the RTX PRO 6000 (Blackwell, sm_120)
  nixpkgs.config.cudaCapabilities = [ "12.0" ];

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

  # ds4 inference server, installed but not started at boot;
  # `systemctl start ds4-server` stops qwen-server and takes over the GPU
  systemd.services.ds4-server = {
    description = "ds4 inference server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ ];
    environment = {
      DS4_CUDA_COPY_MODEL = "1";
    };
    serviceConfig = {
      Type = "simple";
      User = "fabrizio";
      Group = "fabrizio";
      WorkingDirectory = "/home/fabrizio/code/ds4";
      ExecStart = "/home/fabrizio/code/ds4/ds4-server --ctx 250000 --kv-disk-dir /tmp/ds4-kv --kv-disk-space-mb 131072 --kv-cache-cold-max-tokens 100000 --host 0.0.0.0";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  # llama.cpp inference server (Qwen3.8-27B), replaces ds4 at boot
  systemd.services.qwen-server = {
    description = "llama.cpp inference server";
    after = [ "network-online.target" "ds4-server.service" ];
    wants = [ "network-online.target" ];
    # only one model server can hold the GPU at a time
    conflicts = [ "ds4-server.service" "gemma-server.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      LLAMA_CACHE = "/home/fabrizio/.cache/llama.cpp";
    };
    serviceConfig = {
      Type = "simple";
      User = "fabrizio";
      Group = "fabrizio";
      # --kv-unified must be explicit: it defaults on only when --parallel is auto
      ExecStart = "${pkgs.llamaPackages.llama-cpp}/bin/llama serve -hf ggml-org/Qwen3.8-27B-GGUF:Q8_0 --ctx-size 819200 --parallel 4 --kv-unified --ubatch-size 2048 --no-cache-idle-slots --spec-draft-n-max 4 --spec-default --spec-type draft-mtp --reasoning-preserve --agent --reasoning-budget 4096 --reasoning-budget-message \"... I am thinking for too long -- let me gather more info about the task.\" --cache-ram 49152 --host 0.0.0.0 --port 8080";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  # Gemma 4 31B inference server (Q8_0), installed but not started at boot;
  # `systemctl start gemma-server` stops qwen-server and takes over the GPU
  systemd.services.gemma-server = {
    description = "Gemma 4 31B inference server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ ];
    serviceConfig = {
      Type = "simple";
      User = "fabrizio";
      Group = "fabrizio";
      WorkingDirectory = "/home/fabrizio/models/gemma-4-31B-it";
      ExecStart = "${pkgs.llamaPackages.llama-cpp}/bin/llama serve --model /home/fabrizio/models/gemma-4-31B-it/gemma-4-31B-it-Q8_0.gguf --mmproj /home/fabrizio/models/gemma-4-31B-it/mmproj-F16.gguf --spec-draft-model /home/fabrizio/models/gemma-4-31B-it/mtp-gemma-4-31B-it.gguf --ctx-size 262144 --parallel 1 --spec-default --spec-type draft-mtp --batch-size 4096 --ubatch-size 4096 --image-min-tokens 560 --image-max-tokens 2240 --chat-template-file /home/fabrizio/models/gemma-4-31B-it/chat_template.jinja --host 0.0.0.0 --port 8081";
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
