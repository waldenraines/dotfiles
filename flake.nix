{
  description = "walden's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: with inputs;
    let
      username = "walden";
      colorscheme = "tokyonight";
      font-family = "FiraCode Nerd Font";

      hexlib = import ./palettes/hexlib.nix { inherit (nixpkgs) lib; };
      palette = import (./palettes + "/${colorscheme}.nix");
      configDir = ./configs;

      getHomeDirectory = system: with nixpkgs.legacyPackages.${system}.stdenv;
        if isDarwin then
          "/Users/${username}"
        else if isLinux then
          "/home/${username}"
        else "";

      mkNixOSConfig = args: nixpkgs.lib.nixosSystem {
        inherit (args) system;
        specialArgs = {
          homeDirectory = getHomeDirectory args.system;
          inherit (args) machine;
          inherit
            username
            colorscheme
            palette
            configDir
            hexlib
            ;
        };
        modules = [
          ./configuration.nix
        ];
      };

      mkDarwinConfig = args: darwin.lib.darwinSystem {
        inherit (args) system;
        specialArgs = {
          cloudDir = "${getHomeDirectory args.system}/Dropbox";
          inherit (args) machine;
          inherit
            colorscheme
            font-family
            palette
            configDir
            hexlib
            ;
        };
        modules = [
          ./darwin-configuration.nix
        ];
      };

      mkHomeConfig = args: home-manager.lib.homeManagerConfiguration {
        inherit username;
        inherit (args) system;
        homeDirectory = getHomeDirectory args.system;
        stateVersion = "22.05";
        pkgs = import nixpkgs {
          inherit (args) system;
          config = {
            # allowBroken = true;
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
          overlays = [
            neovim-nightly-overlay.overlay
            rust-overlay.overlay
          ];
        };
        extraModules = [
          ./modules/programs/spacebar.nix
          ./modules/programs/vivid.nix
          ./modules/services/yabai.nix
          ./modules/services/skhd.nix
        ];
        extraSpecialArgs = {
          cloudDir = "${getHomeDirectory args.system}/Dropbox";
          inherit (args) machine;
          inherit
            colorscheme
            font-family
            palette
            configDir
            hexlib
            ;
        };
        configuration = import ./home.nix;
      };
    in
    {
      nixosConfigurations.blade = mkNixOSConfig {
        system = "x86_64-linux";
        machine = "blade";
      };

      homeConfigurations."${username}@blade" = mkHomeConfig {
        system = "x86_64-linux";
        machine = "blade";
      };

      darwinConfigurations.skunk = mkDarwinConfig {
        system = "x86_64-darwin";
        machine = "skunk";
      };

      homeConfigurations."${username}@skunk" = mkHomeConfig {
        system = "x86_64-darwin";
        machine = "skunk";
      };
    };
}
