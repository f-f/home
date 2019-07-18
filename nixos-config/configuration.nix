{ config, pkgs, ... }:

{
  imports =
    [
      ../hardware-configuration.nix
      ./local.nix
      ./packages-base.nix
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

  # Docker everywhere
  virtualisation = {
    docker.enable = true;
    docker.autoPrune = {
      enable = true;
      dates = "monthly";
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
      publish.addresses = true;
      publish.workstation = true;
    };    
  };

  # Main user
  users.extraUsers.fabrizio = {
    isNormalUser = true;
    createHome = true;
    uid = 1000;
    home = "/home/fabrizio";
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "wheel" "networkmanager" "docker" "dbus" ];
  };

  
  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # NixOS version
  system.stateVersion = "17.09";
}
