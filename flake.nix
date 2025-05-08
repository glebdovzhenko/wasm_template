{
  description = "My raylib C to WASM compilation setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
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
      in
      {
        devShells.default = pkgs.mkShell {

          nativeBuildInputs = with pkgs; [
            libGL
            xorg.libX11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXinerama
            xorg.libXi
            libxkbcommon
            #emscripten
            (callPackage ./myemsc.nix { })
          ]; 


          shellHook = ''
            cp -r ${pkgs.emscripten}/share/emscripten/cache ~/.emscripten_cache
            chmod u+rwX -R ~/.emscripten_cache
            export EM_CACHE=~/.emscripten_cache
          '';

        };

        devShell = self.devShells.${system}.default;
      }
    );
} 
