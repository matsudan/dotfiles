{
  description = "matsudan's portable CLI environment (Nix flakes + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    herdr.url = "github:ogulcancelik/herdr";
  };

  outputs =
    { nixpkgs, home-manager, herdr, ... }:
    let
      mkHome =
        {
          system,
          username,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              # herdr.overlays.default は rust-overlay を巻き込むので使わない
              (_final: _prev: { herdr = herdr.packages.${system}.default; })
            ];
          };
          extraSpecialArgs = {
            inherit username;
            theme = import ./theme.nix;
          };
          modules = [ ./home ] ++ modules;
        };
    in
    {
      homeConfigurations = {
        mac = mkHome {
          system = "aarch64-darwin";
          username = "matsuda";
        };

        linux = mkHome {
          system = "x86_64-linux";
          username = "matsuda";
        };
      };
    };
}
