{
  description = "Kitty wrapped with NixGL";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixgl.url = "github:guibou/nixGL";

  outputs = { self, nixpkgs, nixgl }:

  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    getBinName = x: with pkgs.lib; x.meta.mainProgram or (getName x);

    wrapWithNixGL = nixGL: pkg:
      pkgs.writeShellApplication {
        name = pkg.pname;

        runtimeInputs = [];

        text = ''
          exec ${nixGL}/bin/nixGL ${pkg}/bin/${getBinName pkg} "$@"
        '';
      };
  in
  {
    packages.x86_64-linux.kittyWithNixGL = wrapWithNixGL nixgl.packages.x86_64-linux.default pkgs.kitty;
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.kittyWithNixGL;
  };
}

