{
  description = "dev-env: A Nix flake project generator";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Flake outputs
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # Development environment output
        devShell = pkgs.mkShell {
          # The Nix packages provided in the environment
          packages = with pkgs; [
            python311Full
            python311Packages.autopep8
          ];
        };

        packages.default = pkgs.python3Packages.buildPythonApplication {
          pname = "dev-env";
          version = "0.0.1";
          pyproject = true;
          src = ./.;

          buildInputs = [
            pkgs.python3
            pkgs.python3Packages.hatchling
          ];

          doCheck = false;

          installPhase = ''
            mkdir -p $out/bin
            cp ${./src/main.py} $out/bin/dev-env
            chmod +x $out/bin/dev-env
          '';
        };
      }
    );
}

