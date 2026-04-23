{
  description = "Strata Renovate library";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      defaultSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      eachSystem =
        with nixpkgs.lib;
        systems: f: foldAttrs mergeAttrs { } (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
      eachDefaultSystem = eachSystem defaultSystems;

      forAllSystems = nixpkgs.lib.genAttrs defaultSystems;
    in
    eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        # Nix formatter available through 'nix fmt' https://github.com/NixOS/nixfmt
        formatter = pkgs.nixfmt;

        packages = { };

        devShells = {
          default = pkgs.mkShell {
            NIX_PATH = "nixpkgs=flake:nixpkgs";

            buildInputs = with pkgs; [
              gawk
              gnugrep
              parallel
              renovate
              unixtools.column
            ];
          };
        };
      }
    );
}
