# Packages list - base
## This config contains the base packages, command line stuff only.

{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  # Nix non-kosher
  nixpkgs.config = {
    allowUnfree = true;
  };

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
    silver-searcher
    tokei
    shellcheck
    mtr
    pbzip2

    # Containers
    docker_compose

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

    # Python
    pythonPackages.yapf
    pythonPackages.magic-wormhole
    pythonPackages.pycodestyle
  ];
}

