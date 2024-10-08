{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls/0.13.0";
    zon2nix.url = "github:MidstallSoftware/zon2nix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ inputs.zig.overlays.default (import inputs.rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };

        zigPkg = pkgs.zigpkgs."0.13.0"; # keep in sync with zls
        zlsPkg = inputs.zls.packages.${system}.default;
        zon2nix = inputs.zon2nix.packages.${system}.default;

        rustAttrs = import ./rust { inherit pkgs; };


        java = pkgs.jdk22;
        # ${java}/include has the headers we need

        node = pkgs.nodejs_22;
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        devShells = {
          default = pkgs.mkShell {
            buildInputs =
              [
                # NOTE: these need to be roughly in sync
                zigPkg
                zlsPkg
                zon2nix

                java

                # node

                rustAttrs.rust-shell

                pkgs.just
                pkgs.time
              ];
          };
        };

        packages = {
          inherit java;
          v8 = node.libv8; # statically compile v8 
        };
      });
}
