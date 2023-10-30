{
  description = "Development environment Haskell - Stack";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , systems
    , nix-vscode-extensions
    , ...
    } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem
        (system:
          let
            pkgs = import nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
            unstable-pkgs = import nixpkgs-unstable {
              system = system;
              config.allowUnfree = true; # Allow proprietary software
            };
            extensions = nix-vscode-extensions.extensions.${system};
            codeWithExtensions =
              let
                inherit (unstable-pkgs) vscode-with-extensions;
                someExtensions = with (extensions.forVSCodeVersion unstable-pkgs.vscode.version).vscode-marketplace; [
                  jnoortheen.nix-ide
                  eamodio.gitlens
                  gruntfuggly.todo-tree
                  vscode-icons-team.vscode-icons
                  haskell.haskell
                  justusadam.language-haskell
                  # anweber.vscode-httpyac
                  humao.rest-client
                ];
              in
              (vscode-with-extensions.override {
                vscodeExtensions = someExtensions;
              });
          in
          {
            default = pkgs.mkShell {

              NIX_PATH = "nixpkgs=" + pkgs.path;

              buildInputs = with pkgs;[
                haskell-language-server
                stack
                ghc
              ] ++ [ codeWithExtensions ];
            };
          });

    };

  # outputs = { self, nixpkgs, flake-utils }:
  #   flake-utils.lib.eachDefaultSystem (system:
  #     let
  #       inherit (nixpkgs.lib) optional;
  #       pkgs = import nixpkgs { inherit system; };

  #     in

  #     {
  #       devShell = pkgs.mkShell
  #         {
  #           buildInputs = with pkgs;[
  #             nodejs-16_x
  #             nodePackages."@angular/cli"
  #           ];

  #           shellHook = ''
  #             echo node environment
  #             echo angular version
  #             ng v
  #           '';
  #         };
  #     }
  #   );
}
