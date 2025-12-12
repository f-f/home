{
  description = "f-f's nix stuffs";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-25.11;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
    darwin.url = github:lnl7/nix-darwin;
    home-manager.url = github:nix-community/home-manager/release-25.11;
    # nix will normally use the nixpkgs defined in home-managers inputs, but we only want one copy
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }@inputs: {
    nixosConfigurations.claudius = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./linux.nix
        ./claudius.nix
      ];
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
    nixosConfigurations.domitian = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./linux.nix
        ./domitian.nix
      ];
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };

    darwinConfigurations.tiberius = darwin.lib.darwinSystem {
      specialArgs = {
        nix-env-config.os = "darwin";
        hostname = "tiberius";
      };
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        ./macos.nix
      ];
    };
    darwinConfigurations.aurelius = darwin.lib.darwinSystem {
      specialArgs = {
        nix-env-config.os = "darwin";
        hostname = "aurelius";
      };
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        ./macos.nix
      ];
    };
  };
}
