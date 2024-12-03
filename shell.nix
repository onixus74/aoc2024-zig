{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    direnv
    asdf-vm
    just
    tilt
  ];

  shellHook = ''
    echo "Zig AOC 2024 development environment"
    just --list
  '';
}
