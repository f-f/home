{
  description = "f-f's nix stuffs";

  inputs = {
    nixpkgs-linux.url = github:nixos/nixpkgs/nixos-26.05;
    nixpkgs-darwin.url = github:nixos/nixpkgs/nixpkgs-26.05-darwin;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
    darwin.url = github:nix-darwin/nix-darwin/nix-darwin-26.05;
    home-manager.url = github:nix-community/home-manager/release-26.05;
    # nix will normally use the nixpkgs defined in home-managers inputs, but we only want one copy
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-darwin";
    # tracks master; bump with `nix flake update llama-cpp`
    llama-cpp.url = github:ggml-org/llama.cpp;
    llama-cpp.inputs.nixpkgs.follows = "nixpkgs-linux";
  };

  outputs = { self, nixpkgs-linux, nixpkgs-darwin, nixpkgs-unstable, darwin, home-manager, ... }@inputs: {
    nixosConfigurations.augustus = nixpkgs-linux.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./linux.nix
        ./augustus.nix
        { nixpkgs.overlays = [ inputs.llama-cpp.overlays.default ]; }
      ];
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
    nixosConfigurations.claudius = nixpkgs-linux.lib.nixosSystem rec {
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
    nixosConfigurations.domitian = nixpkgs-linux.lib.nixosSystem rec {
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
        # Fish tests are broken for direnv 🤷
        {
          nixpkgs.overlays = [(final: prev: {
            direnv = prev.direnv.overrideAttrs (old: { doCheck = false; });
          })];
         }
      ];
    };
  };
}
