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
              # herdr だけを pkgs に足す。
              # herdr.overlays.default は rust-overlay を composeExtensions で
              # 巻き込むため、pkgs 全体に rust-overlay が載る。
              # ここでは upstream がビルド済みの派生を差すだけに留める。
              (_final: _prev: { herdr = herdr.packages.${system}.default; })
            ];
          };
          # home/*.nix から username を参照
          extraSpecialArgs = { inherit username; };
          modules = [ ./home ] ++ modules;
        };
    in
    {
      homeConfigurations = {
        # macOS / Apple Silicon
        #   home-manager switch --flake .#mac
        mac = mkHome {
          system = "aarch64-darwin";
          username = "matsuda";
        };

        # Linux / x86_64
        #   home-manager switch --flake .#linux
        linux = mkHome {
          system = "x86_64-linux";
          username = "matsuda";
        };
      };
    };
}
