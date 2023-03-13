# based on the flake example on https://github.com/oxalica/rust-overlay
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";

    ldproxy.url = "github:tufteddeer/esp32-rs-nix?dir=ldproxy";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ldproxy }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {

          # see https://esp-rs.github.io/book/installation/installation.html#installing-rust-for-espressif-socs

          buildInputs = [

            (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
              extensions = [ "rust-src" ];

            }))

            ldproxy.packages.${system}.default

            cargo-espflash

            # idf-sys dependencies
            python3
            python3.pkgs.pip
            python3.pkgs.virtualenv

            libclang.lib

          ];

          # bindgen needs to find libclang.so
          LIBCLANG_PATH = lib.makeLibraryPath [ libclang.lib ];

        };
      }
    );
}
