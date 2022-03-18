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
    manpages
    tldr
    graphviz
    gnumake
    silver-searcher
    tokei
    shellcheck
    mtr
    bat
    pbzip2
    wireguard
    direnv
    bind
    lm_sensors
    ddrescue

    # Development
    stack
    gcc
    git
    nodejs
    python3
    erlang
    docker_compose
    unstable.spago
    unstable.purescript
  ];
}

