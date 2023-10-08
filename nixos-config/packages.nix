# Packages

{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  # Nix non-kosher
  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    # Utilities
    jq
    curl
    wget
    httpie
    tree
    unzip
    gnupg
    htop
    iftop
    man-pages
    tldr
    graphviz
    gnumake
    silver-searcher
    tokei
    shellcheck
    mtr
    bat
    pbzip2
    wireguard-tools
    direnv
    bind
    lm_sensors
    ddrescue
    screen
    tmux
    magic-wormhole
    file
    httm
    fzf

    # Development
    stack
    gcc
    git
    nodejs
    python3
    erlang
    docker-compose
  ];
}

