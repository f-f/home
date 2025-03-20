{ config, pkgs, ... }:

{
  imports =
    [
      ./packages.nix
    ];

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  time.timeZone = "Europe/Helsinki";

  # Common program configurations here
  programs = {
    vim.enable = true;
    vim.defaultEditor = true;
    bash.completion.enable = true;
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
      nssmdns4 = true;
      publish.enable = true;
      publish.addresses = true;
      publish.workstation = true;
    };
    openssh = {
      enable = true;
      ports = [ 10000 ];
      settings = {
        PermitRootLogin = "no";
        X11Forwarding = true;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
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
}
