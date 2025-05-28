{
  description = "My raylib C to WASM compilation setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    glebpkgs.url = "github:glebdovzhenko/nixos-config";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , glebpkgs
    , ...
    }:
    let
      overlays = [ ];
      systems = [ "x86_64-linux" ];
    in
    flake-utils.lib.eachSystem systems (
      system:
      let
        pkgs = import nixpkgs { inherit overlays system; };
        emscripten = pkgs.callPackage "${glebpkgs}/pkgs/emscripten" { };
      in
      {
        devShells.default = pkgs.mkShell {

          nativeBuildInputs = with pkgs; [
            # raylib deps
            libGL
            xorg.libX11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXinerama
            xorg.libXi
            libxkbcommon
          ] ++ [ emscripten ];

          shellHook = ''
            # this is a requirement for emcc, otherwise it tries to cache things
            # in its installation folder
            cp -r ${pkgs.emscripten}/share/emscripten/cache ~/.emscripten_cache
            chmod u+rwX -R ~/.emscripten_cache
            export EM_CACHE=~/.emscripten_cache
            # this is required for raylib makefile
            export EMSCRIPTEN_PATH="${emscripten}"
          '';

        };

        devShell = self.devShells.${system}.default;
      }
    );
} 
