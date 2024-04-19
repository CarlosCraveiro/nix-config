{
    inputs = {
        nixpkgs.url = github:NixOS/nixpkgs/master;
 
        home-manager.url = github:nix-community/home-manager/master;
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        agenix.url = github:ryantm/agenix;
        agenix.inputs.nixpkgs.follows = "nixpkgs";
        tomato-c.url = "github:gabrielzschmitz/Tomato.C";
        tomato-c.inputs.nixpkgs.follows = "nixpkgs";
        nix-colors.url = "github:misterio77/nix-colors";
        battery-notifier.url = "github:luisnquin/battery-notifier";
    };
      outputs = { self, nixpkgs, home-manager, agenix, battery-notifier,  ... }@attrs:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config = {
             allowUnfree = true;
             permittedInsecurePackages = [ ];
           };
            overlays = [];
        };

        lib = nixpkgs.lib // home-manager.lib;
    in
  {
    nixosConfigurations.roxanne = lib.nixosSystem {
      inherit system;
      inherit pkgs;
      
      specialArgs = attrs;
      
      modules = [ 
        ./configuration.nix
        agenix.nixosModules.default 
      ];
    };
     homeConfigurations = {
      # Desktops
      coveiro = lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
            ./home.nix
            {
                home = {
                    username = "coveiro";
                    homeDirectory = "/home/coveiro";
                };
            }
            battery-notifier.homeManagerModule.default
            {
          services.battery-notifier = {
            enable = true;
            settings = {
              icon_path = "/home/coveiro/Downloads/SVG/\"LD+R Ofer's Skull.svg\""; # Nix path
              interval_ms = 700;
              reminder = {threshold = 50;}; 
              warn = {threshold = 30;};
              threat = {threshold = 12;};
            };
          };
        }
        ];
      };
    };
  };
}
