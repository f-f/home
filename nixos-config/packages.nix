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
    lm_sensors
    ddrescue

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
    silver-searcher
    tokei
    shellcheck
    mtr
    pbzip2
    wireguard
    direnv
    bind

    # Development
    leiningen
    boot
    stack
    gcc
    git
    maven
    openjdk
    nodejs
    python3
    docker_compose
    unstable.spago
    unstable.purescript
  ];
}

