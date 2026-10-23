{
  description = "matsudan's portable CLI environment (Nix flakes + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    herdr.url = "github:ogulcancelik/herdr";

    # opencode だけ新しいバージョンに追従するための nixpkgs
    # (nixos-26.05 は古く、upstream flake は darwin で codesign が失敗する)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      herdr,
      ...
    }:
    let
      mkHome =
        { system, username }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              # herdr.overlays.default は rust-overlay を巻き込むので使わない
              (_final: _prev: { herdr = herdr.packages.${system}.default; })

              # bun 1.4.4 は nixpkgs (stable/unstable とも) に未反映なため upstream の
              # ビルド済みバイナリを使って override する。nixpkgs が 1.4.4 以上に
              # 追従したらこの overlay は削除する
              (_final: prev: {
                bun = prev.bun.overrideAttrs (
                  finalAttrs: _prevAttrs: {
                    version = "1.4.4";
                    __intentionallyOverridingVersion = true;
                    passthru = _prevAttrs.passthru // {
                      sources = {
                        "aarch64-darwin" = prev.fetchurl {
                          url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-darwin-aarch64.zip";
                          hash = "sha256-wkDX8My5DCY6hJ/NsJt+5iYw2SE0jtaq/ahrnVd7xRA=";
                        };
                        "aarch64-linux" = prev.fetchurl {
                          url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-aarch64.zip";
                          hash = "sha256-uqa7NvUdblhWHgK76oJQOKnfRU9nPW13bou/hvjHhQ4=";
                        };
                        "x86_64-linux" = prev.fetchurl {
                          url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-x64-baseline.zip";
                          hash = "sha256-4ERutVmVdy65iUvrrppr42jZhai5Jx7hJEhvmUbu3XY=";
                        };
                      };
                    };
                  }
                );
              })
            ];
          };
          extraSpecialArgs = {
            inherit username;
            opencodePackage = nixpkgs-unstable.legacyPackages.${system}.opencode;
            # GHSA-hq85-5cpj-mr62 対応の 0.13.4 以上が必要。unstable に来たら override は削除
            uvPackage =
              let
                upkgs = nixpkgs-unstable.legacyPackages.${system};
              in
              upkgs.uv.overrideAttrs (
                finalAttrs: _prev: {
                  version = "0.13.4";
                  src = upkgs.fetchFromGitHub {
                    owner = "astral-sh";
                    repo = "uv";
                    tag = finalAttrs.version;
                    hash = "sha256-US3SjwhWE3v4/i46YuBon2GA6PupC4Z0NRUqcV9CPLM=";
                  };
                  # overrideAttrs では cargoHash が効かないため
                  cargoDeps = upkgs.rustPlatform.fetchCargoVendor {
                    inherit (finalAttrs) pname version src;
                    hash = "sha256-9L47CTlkOVYfGuzE4e7e2FYAI192pAsipzzScF7B1j4=";
                  };
                }
              );
            theme = import ./theme.nix;
          };
          modules = [ ./home ];
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
