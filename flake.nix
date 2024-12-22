{
  description = "Custom Iosevka build";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          pname = "iosevka-custom";
        in
        {
          default = pkgs.callPackage ./nix/package.nix { inherit pname; };
        });
    };
}
