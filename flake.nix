{
  description = "microca: microca is a small, simple Certificate Authority tool.";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      lastModifiedDate =
        self.lastModifiedDate or self.lastModified or "19700101";
      version = builtins.substring 0 8 lastModifiedDate;
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          microca = pkgs.buildGoModule {
            pname = "microca";
            inherit version;
            src = ./.;

            vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

            proxyVendor = true;
          };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.microca);
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in { default = pkgs.mkShell {
          shellHook = ''
            PS1='\u@\h:\@; '
          '';
          nativeBuildInputs = with pkgs; [ git go gopls go-tools ];
        }; });
    };
}
