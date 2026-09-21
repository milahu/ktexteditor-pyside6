{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  ktexteditor-pyside6 = python3.pkgs.callPackage ./default.nix { };
in

mkShell {
  buildInputs = [
    (python3.withPackages (pp: with pp; [
      ktexteditor-pyside6
    ]))
  ];
}
