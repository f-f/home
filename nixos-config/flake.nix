{
  description = "f-f's nix stuffs";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    darwin.url = github:lnl7/nix-darwin;
    home-manager.url = github:nix-community/home-manager;
    # nix will normally use the nixpkgs defined in home-managers inputs, but we only want one copy
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs: {
    darwinConfigurations.hadrianus = darwin.lib.darwinSystem {
      specialArgs = {
        nix-env-config.os = "darwin";
      };
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        ./hadrianus.nix
      ];
    };
  };
}
