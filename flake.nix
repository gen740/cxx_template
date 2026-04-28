{
  description = "C++ template with CMake, Ninja, and Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.llvmPackages_21.clang-tools
              pkgs.llvmPackages_21.libcxxClang
              pkgs.llvmPackages_21.bintools
              pkgs.cmake
              pkgs.cmake-format
              pkgs.cmake-language-server
              pkgs.ninja
              pkgs.gtest
              pkgs.nixfmt-rfc-style
            ];
          };

          packages.default = pkgs.llvmPackages_21.libcxxStdenv.mkDerivation {
            name = "cxx-template";
            src = ./.;
            nativeBuildInputs = [
              pkgs.cmake
              pkgs.ninja
            ];
            buildInputs = [
              pkgs.gtest
            ];
            cmakeFlags = [
              "-G Ninja"
              "-DCMAKE_BUILD_TYPE=Release"
              "-DCXX_TEMPLATE_ENABLE_TEST=ON"
            ];
            doCheck = true;
            checkPhase = ''
              runHook preCheck
              ctest --output-on-failure
              runHook postCheck
            '';
          };

          apps.build = {
            type = "app";
            program =
              (pkgs.writeShellScript "build-cxx-template" ''
                set -euo pipefail
                if [ ! -d build ]; then
                  nix develop --command cmake -S . -B build -G Ninja \
                    -DCMAKE_BUILD_TYPE=Debug \
                    -DCXX_TEMPLATE_ENABLE_TEST=ON \
                    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
                fi
                nix develop --command cmake --build build
              '').outPath;
          };
        };
    };
}
