# Nix flakes for ESP32 development using Rust

**Only works with ESP models featuring a RISC-V chip**

`ldproxy/` contains a flake that builds [ldproxy](https://github.com/esp-rs/embuild/tree/master/ldproxy).

The flake in the root directory provides the Rust nightly toolchain, dependencies to build [esp-idf-sys](https://crates.io/crates/esp-idf-sys) and [cargo-espflash](https://crates.io/crates/cargo-espflash).

## Usage

You can either copy `flake.nix` as a starting point for your own configuration, or use it as input:

```nix
{

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    esp32-rs.url = "github:tufteddeer/esp32-rs-nix";
  };

  outputs = { self, nixpkgs, flake-utils, esp32-rs }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShells.default = esp32-rs.devShells.${system}.default;
      }
    );
}
```