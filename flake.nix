{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        repl = pkgs.writeShellScriptBin "repl" ''
          clj -M:repl/node
        '';
        tests = pkgs.writeShellScriptBin "tests" ''
          clj -M:test
        '';
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShellNoCC {
          shellHook = ''
            echo Run one of:
            echo  -e "\t repl"
            echo  -e "\t tests"
          '';

          packages = [
            repl tests
            pkgs.clojure pkgs.nodejs
          ];
        };
      });
}
