{
  description = "AmbiguousTechnologies Home Manager profile";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/nixos/nixpkgs/0.2411.*";
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/*.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: genAttrs allSystems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      # Standalone home-manager configuration
      # - nix run nixpkgs#home-manager -- build --flake .#user@robot
      # - nix run nixpkgs#home-manager -- build --flake .#user@workstation
      homeConfigurations = {
        # For the NixOS (x86) robot
        "user@robot" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [ ./home-manager ];
        };
        # For the macOS (x86) developer workstation
        "user@workstation" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-darwin;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [ ./home-manager ];
        };
      };
    };
}
