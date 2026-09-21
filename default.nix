{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  cmake,
  ninja,
  scikit-build-core,
  build,
  setuptools,
  pyside6,
  shiboken6,
  qt6,
  kdePackages,
}:

let
  pythonEnv = python.withPackages (ps: [
    build
    pyside6
    shiboken6
  ]);
in

buildPythonPackage {
  pname = "ktexteditor-pyside6";
  version = "0.1.0";

  src = ./.;
  # TODO
  /*
  src = fetchFromGitHub {
    owner = "milahu";
    repo = "ktexteditor-pyside6";
    tag = "";
    hash = "";
  };
  */

  pyproject = true;

  nativeBuildInputs = [
    cmake
    ninja # for scikit-build-core
    kdePackages.extra-cmake-modules # ECMGeneratePythonBindings.cmake
    scikit-build-core
    shiboken6
    # fix: The 'build' Python module is needed for ECMGeneratePythonBindings
    build
    setuptools
    # make cmake use this python env
    # fix: The 'build' Python module is needed for ECMGeneratePythonBindings
    # TODO better?
    pythonEnv
  ];

  dependencies = [
    pyside6
  ];

  buildInputs = [
    qt6.qtbase
    kdePackages.ktexteditor
  ];

  dontWrapQtApps = true;

  dontUseCmakeConfigure = true;
  dontUseCmakeBuild = true;
  dontUseCmakeInstall = true;

  # help cmake find ${kdePackages.extra-cmake-modules}/share/ECM/modules/ECMGeneratePythonBindings.cmake
  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${kdePackages.extra-cmake-modules}/share/ECM/modules"
    # "-DKDE_EXTRA_CMAKE_MODULES=${kdePackages.extra-cmake-modules}/share/ECM/modules"

    # make cmake use this python env
    # fix: The 'build' Python module is needed for ECMGeneratePythonBindings
    # TODO better?
    "-DPython3_EXECUTABLE=${pythonEnv}/bin/python"
    "-DPython_EXECUTABLE=${pythonEnv}/bin/python"
    "-DCMAKE_MODULE_PATH=${kdePackages.extra-cmake-modules}/share/ECM/modules"
  ];
}
