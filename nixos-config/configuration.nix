{ config, pkgs, ... }:

{
  imports =
    [
      ../hardware-configuration.nix
      ./local.nix
      ./packages.nix
    ];

  time.timeZone = "Europe/Helsinki";

  # Common program configurations here
  programs = {
    vim.defaultEditor = true;
    bash.enableCompletion = true;
    java.enable = true;
    zsh.enable = true;
    ssh.startAgent = true;
  };

  # Docker and libvirt
  virtualisation = {
    docker.enable = true;
    docker.autoPrune = {
      enable = true;
      dates = "monthly";
    };
    libvirtd.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
      publish.addresses = true;
      publish.workstation = true;
    };    
    openssh = {
      enable = true;
      permitRootLogin = "no";
      ports = [ 10000 ];
      forwardX11 = true;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
    };
  };

  users.users.fabrizio = {
    isNormalUser = true;
    createHome = true;
    uid = 1000;
    home = "/home/fabrizio";
    shell = "/run/current-system/sw/bin/zsh";
    group = "fabrizio";
    extraGroups = [ "wheel" "networkmanager" "docker" "dbus" "libvirtd" ];
  };
  users.groups.fabrizio = {};

  
  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # NixOS version
  system.stateVersion = "21.05";
}
