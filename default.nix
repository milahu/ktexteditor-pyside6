{
  pkgs ? import <nixpkgs> { }
}:

with pkgs;

let
  shiboken6 = python3.pkgs.shiboken6;
  pyside6 = python3.pkgs.pyside6;
in

# FIXME ktexteditor-pyside6 should be a python package with a pyproject.toml file
# buildPythonPackage {
#   format = "pyproject";

# clangStdenv.mkDerivation {
stdenv.mkDerivation {
  pname = "ktexteditor-pyside6";
  version = "0.0.1";
  src = ./.;
  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules # ECMGeneratePythonBindings.cmake
    (python3.withPackages (pp: with pp; [
      # shiboken6
      shiboken6
      shiboken6-generator
      # pyside6
      pyside6
      # fix: The 'build' Python module is needed for ECMGeneratePythonBindings
      build
      # fix: ERROR Backend 'setuptools.build_meta:__legacy__' is not available.
      setuptools
    ]))
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qtbase.dev
    kdePackages.ktexteditor
    glibc_multi # stdc-predef.h stdlib.h ...
  ];
  # help cmake find ${kdePackages.extra-cmake-modules}/share/ECM/modules/ECMGeneratePythonBindings.cmake
  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${kdePackages.extra-cmake-modules}/share/ECM/modules"
    # "-DKDE_EXTRA_CMAKE_MODULES=${kdePackages.extra-cmake-modules}/share/ECM/modules"
  ];
  dontWrapQtApps = true;
  postInstall = ''
    mkdir -p $out/${pkgs.python3.sitePackages}
    mv -v $out/lib/python-kf6/KTextEditor.cpython-*.so $out/${pkgs.python3.sitePackages}
    rmdir $out/lib/python-kf6
  '';
  # enableParallelBuilding = false; # debug
  # preBuild = "set -x"; # debug
  # makeFlags = [ "-d" ]; # debug
}
