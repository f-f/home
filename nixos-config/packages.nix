# Packages list
## Note: does not contain configuration for software that is
## already covered by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  # Nix meta-config
  nixpkgs.config.allowUnfree = true;

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

    # Desktop
    alacritty
    gnome3.dconf
    gnome3.glib_networking
    lxappearance-gtk3
    numix-gtk-theme
    numix-icon-theme
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
    unstable.silver-searcher
    unstable.tokei
    unstable.tigervnc
    unstable.anki
    unstable.dropbox
    unstable.numix-cursor-theme
    unstable.postgresql96
    unstable.jetbrains.pycharm-community
  ];
}

