# Packages

{ config, pkgs, pkgs-unstable, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
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
    traceroute
    tailscale

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

