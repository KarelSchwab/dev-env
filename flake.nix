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
          python311Packages.build
        ];
      };

      packages.default = pkgs.python3Packages.buildPythonApplication {
        pname = "dev-env";
        version = "0.0.1";
        src = ./.;

        buildInputs = [ pkgs.python3 ];

        doCheck = false;

        installPhase = ''
          mkdir -p $out/bin
          cp ${./src/main.py} $out/bin/main.py
          chmod +x $out/bin/main.py
        '';

        meta = with pkgs.lib; {
          description = "A Nix flake project generator";
          license = licenses.mit;
          # maintainers = with maintainers; [ your-github-username ];
        };
      };
    });
}
      # Development environment output
      # devShells = forAllSystems ({ pkgs }: {
      #   default = pkgs.mkShell {
      #     # The Nix packages provided in the environment
      #     packages = with pkgs; [
      #       python311Full
      #       python311Packages.autopep8
      #       python311Packages.build
      #     ];
      #   };
      # });
    # }
