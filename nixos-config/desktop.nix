{ config, pkgs, ... }:

{
  imports =
    [
      ./packages-desktop.nix
    ];

  # Configure audio setup
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull.override { jackaudioSupport = true; };
    support32Bit = true;
    daemon.config = { default-sample-rate = 48000; };
  };
  sound.enable = true;
  hardware.enableAllFirmware = true;
 
  location.latitude = 60.169856;
  location.longitude = 24.938379;
 
  services = {
    # Redshift for Helsinki
    redshift = {
      enable = true;
      temperature = {
        day = 6500;
        night = 2800;
      };
    };
    
    # Enable X11 
    xserver.enable = true;
    xserver.layout = "us";
    xserver.xkbOptions = "eurosign:e";
    xserver.displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
    };
    xserver.desktopManager = {
      gnome3.enable = true;
    };

    gnome3.chrome-gnome-shell.enable = true;
    gnome3.gnome-keyring.enable = true;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      source-code-pro
      font-awesome-ttf
      fira-code
      fira-code-symbols
      dejavu_fonts
      unifont
      ubuntu_font_family
      liberation_ttf
    ];
  };

  # Common desktop systemd services
  systemd.user.services.dowloads-wipe = {
    description = "Nuke downloads folder";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'rm -rf /home/fabrizio/Downloads/*'";
    };
  };

  systemd.user.timers.downloads-wipe = {
    description = "Nuke downloads folder on boot";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
    };
  };

  systemd.services.downloads-wipe.enable = true;
  systemd.timers.downloads-wipe.enable = true;

  # Full 3D acceleration for 32b programs
  hardware.opengl.driSupport32Bit = true;

  # Also steam controller
  # hardware.steam-hardware.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
    KERNEL=="uinput", MODE="0660", GROUP="users", OPTIONS+="static_node=uinput"
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"
    KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0666" 
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"
    KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666"
    KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0666"
  '';

  # Enable bluetooth
  hardware.bluetooth.enable = true;
}
