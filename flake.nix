{
    inputs.nixpkgs.url = github:NixOS/nixpkgs/master;
 
    inputs.home-manager.url = github:nix-community/home-manager/master;
    inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
    inputs.agenix.url = github:ryantm/agenix;
    inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";
    inputs.tomato-c.url = "github:gabrielzschmitz/Tomato.C";
    inputs.tomato-c.inputs.nixpkgs.follows = "nixpkgs";
    #inputs.nix-colors.url = "github:misterio77/nix-colors";
    inputs.battery-notifier.url = "github:CarlosCraveiro/battery-notifier";
    
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
        battery-notifier.homeManagerModule.default
        {
          programs.battery-notifier = {
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
        ];
        #modules = [./home/misterio/atlas.nix];
        #pkgs = pkgsFor.x86_64-linux;
        #extraSpecialArgs = {
        #  inherit inputs outputs;
        #};
      };
    };
  };
}
