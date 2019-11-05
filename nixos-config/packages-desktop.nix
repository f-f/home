# Packages list - desktop
## Note: does not contain configuration for software that is
## already covered by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let unstable = import <nixos-unstable> {
  config = {
    allowUnfree = true;
    packageOverrides = pkgs: rec {
      rtmidi = pkgs.rtmidi.overrideAttrs (oldAttrs: rec {
        preConfigure = ''
          ./autogen.sh --with-jack --with-alsa
          ./configure
        '';
      });
    };
  };
};
in {
  # Nix meta-config
  nixpkgs.config = {
    allowUnfree = true;

    firefox = {
      enableGoogleTalkPlugin = true;
      enableGnomeExtensions = true;
    };

    chromium = {
      enablePepperFlash = true;
    };

    #packageOverrides = super: let self = super.pkgs; in
    #  {
    #    linuxPackages = super.linuxPackages_latest.extend (self: super: {
    #      nvidiaPackages = super.nvidiaPackages // {
    #        stable = unstable.linuxPackages_latest.nvidiaPackages.stable;
    #      };
    #    });
    #  };
  };

  # Finally, packages
  environment.systemPackages = with pkgs; [

    # Gnome
    chrome-gnome-shell
    gnome3.dconf
    gnome3.glib_networking
    gnome3.gnome-shell-extensions
    lxappearance-gtk3
    unstable.numix-gtk-theme
    unstable.numix-icon-theme
    unstable.numix-cursor-theme
    # gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.dash-to-panel
    unstable.gnomeExtensions.timepp

    # Desktop apps
    unstable.alacritty
    steam
    keepassx-community
    calibre
    gparted
    synergy
    unstable.emacs

    # Audio
    unstable.pavucontrol
    unstable.qjackctl
    unstable.vlc
    unstable.jack2
    unstable.libjack2
    unstable.cadence
    unstable.spotify
    unstable.ardour

    # Internet
    firefox
    google-chrome

    # Messaging
    unstable.tdesktop
    slack

    # Devops
    kubernetes
    terraform
    unstable.google-cloud-sdk

    # Haskell packages
    haskellPackages.stylish-haskell

    # Dev pkgs
    ncurses

    # Other
    ntfs3g

    # Unstable packages:
    unstable.anki
    unstable.cabal-install
    unstable.dropbox
    unstable.supercollider
    unstable.postgresql96
    unstable.yarn
    unstable.stack
    unstable.steamcontroller
  ];
}

