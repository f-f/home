{ config, pkgs, ... }:

{
  # Configure audio setup for JACK + Overtone
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  
  services = {
    # Redshift for Helsinki
    redshift = {
      enable = true;
      latitude = "60.169856";
      longitude = "24.938379";
      temperature = {
        day = 6500;
        night = 2800;
      };
    };

    # Enable CUPS
    printing = {
      enable = true;
      drivers = [ pkgs.samsung-unified-linux-driver_4_01_17 ];
    };

    # TV on every desktop
    teamviewer.enable = true;
 
    # Enable X11 
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      videoDrivers = [ "nvidia" ];
 
      displayManager = {
        gdm.enable = true;
      };
      desktopManager = {
        gnome3.enable = true;
        default = "gnome3";
      };
    };

    gnome3.chrome-gnome-shell.enable = true;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      font-awesome-ttf
      fira-code
      fira-code-symbols
      dejavu_fonts
      unifont
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

  # Enable bluetooth
  hardware.bluetooth.enable = true;
}
