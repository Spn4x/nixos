{
  description = "Meismeric's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    nixpkgs-batch1.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-batch2.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-batch3.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-batch4.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-batch5.url = "github:nixos/nixpkgs/nixos-26.05";

    # Pinned Packet Tracer input
    nixpkgs-pt.url = "github:nixos/nixpkgs?rev=02e08985a27c65ffd33d434eeb2e660a2e4dc84d";

    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
   # noctalia = {
   # url = "github:noctalia-dev/noctalia";
   # inputs.nixpkgs.follows = "nixpkgs"; 
   # };
   };

  outputs = { self, nixpkgs, zen-browser, freesmlauncher, ... }@inputs: 
  let
    system = "x86_64-linux";
    
    # Configure the unstable package set to allow unfree apps
    # pkgs-unstable = import nixpkgs-unstable {
    #   inherit system;
    #   config.allowUnfree = true;
    # };
  in {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      inherit system;
      
      # Passes flake inputs into configuration.nix
      specialArgs = { inherit inputs; };
      
      modules = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
      ];
    };
  };
}