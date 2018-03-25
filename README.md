# dotfiles

Repository for my dotfiles; in this current iteration I'm just versioning `$HOME`.

Config for NixOS only.

## Fresh install, wat do

1. Clone this repo in the home folder, then `git submodule update --init --recursive --remote`
2. Symlink `~/nixos-config` to `/etc/nixos/versioned`: `sudo ln -sv ~/nixos-config /etc/nixos/versioned`
3. Write down the config for the new machine
4. Symlink the current machine configuration to `cd ~/nixos-config && ln -sv $(hostname).nix local.nix`
5. Symlink the main config: `sudo ln -sv /etc/nixos/versioned/configuration.nix /etc/nixos/configuration.nix`
6. Add channels:
 ```
 sudo nix-channel --add http://nixos.org/channels/nixos-17.09 nixos
 sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
 sudo nix-channel --update
 ```

Then: `nixos-rebuild switch`

Next:
1. Make a new ssh key for github: `ssh-keygen -t rsa -b 4096 -C "$USER@$(hostname)" -f github`
2. Replace this repo remote http->git
