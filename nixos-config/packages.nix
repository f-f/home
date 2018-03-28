# Packages list
## Note: does not contain configuration for software that is
## already covered by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  # Nix meta-config
  nixpkgs.config = {
    allowUnfree = true;

    firefox = {
      enableGoogleTalkPlugin = true;
      enableGnomeExtensions = true;
      enableAdobeFlash = true;
    };

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  # Finally, packages
  environment.systemPackages = with pkgs; [
    # Basic terminal
    jq
    curl
    wget
    httpie
    tree
    unzip
    gnupg
    htop
    iftop
    manpages
    tldr
    graphviz
    gnumake
    autojump
    silver-searcher
    tokei
    shellcheck

    # Gnome
    chrome-gnome-shell
    gnome3.dconf
    gnome3.glib_networking
    gnome3.gnome-shell-extensions
    lxappearance-gtk3
    numix-gtk-theme
    numix-icon-theme
    numix-cursor-theme
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.dash-to-panel
    gnomeExtensions.nohotcorner
    unstable.gnomeExtensions.timepp
    #gnome-shell-extension-impatience
    #gnomeExtensions.system-monitor
    #gnomeExtensions.volume-mixer

    # Desktop apps
    alacritty
    steam
    keepassx-community
    calibre
    gparted
    synergy

    # Audio
    pavucontrol
    qjackctl
    vlc
    spotify
    ardour

    # Internet
    firefox
    google-chrome

    # Messaging
    tdesktop
    slack

    # Cloud
    docker_compose
    kubernetes
    unstable.google-cloud-sdk

    # Development
    emacs
    leiningen
    boot
    stack
    gcc
    git
    maven
    openjdk
    nodejs
    python3

    # Haskell
    haskellPackages.stylish-haskell

    # Python
    unstable.pythonPackages.yapf
    unstable.pythonPackages.pycodestyle

    # Unstable packages:
    unstable.tigervnc
    unstable.anki
    unstable.dropbox
    unstable.postgresql96
    unstable.jetbrains.pycharm-community
    unstable.teamviewer
  ];
}

