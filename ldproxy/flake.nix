# flake based on https://www.tweag.io/blog/2022-09-22-rust-nix/
# and https://nixos.org/manual/nixpkgs/stable/#rust
{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";

    embuild = {
      url = "github:esp-rs/embuild/ldproxy-v0.3.2";
      flake = false;
    };

  };

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        code = pkgs.callPackage ./. { inherit nixpkgs system rust-overlay; };
      in
      rec {
        packages = {
          app = pkgs.rustPlatform.buildRustPackage {
            pname = "ldproxy";
            version = "0.3.2";
            src = embuild;

            cargoSha256 = "sha256-u4G5LV/G6Iu3FUeY2xdeXgVdiXLpGIC2UUYbUr0w3n0=";

            buildAndTestSubdir = "./ldproxy";
          };

          default = packages.app;
        };
      }
    );
}
