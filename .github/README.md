# home

Versioning `$HOME`. Contains nix configs, dotfiles, scripts.

Config for NixOS only.

## Fresh install, wat do

1. Clone this repo in the home folder: `git clone https://github.com/f-f/home.git ~`
1. Fetch everything: `cd ~ && git submodule update --init --recursive --remote`
1. Write down the config for the new machine, start from the example: `cd ~/nixos-config && cp local-example.nix $(hostname).nix`, and integrate with what's in `/etc/nixos/configuration.nix`
1. Import it as a local configuration: `echo "import ./$(hostname).nix" > local.nix`
1. `mv /etc/nixos/hardware-configuration.nix ~`
1. Add channels:
 ```
 sudo nix-channel --add http://nixos.org/channels/nixos-20.09 nixos
 sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
 sudo nix-channel --update
 ```

Then: `nixos-switch`

Next:
1. Make a new ssh key for github: `ssh-keygen -t rsa -b 4096 -C "$USER+github@$(hostname)" -f github`, add it as deploy key here
2. Replace this repo remote from http to git: `git remote set-url origin git@github.com:f-f/dotfiles.git`
