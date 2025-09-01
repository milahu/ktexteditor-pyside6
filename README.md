# PySide6 bindings for KDE KTextEditor (skeleton)

This is a **minimal Shiboken/PySide6 binding skeleton** for the KDE Frameworks
**KTextEditor** component (KF6). It exposes a tiny subset of the API:
- `KTextEditor::Editor` (singleton access)
- `KTextEditor::Document`
- `KTextEditor::View` (a QWidget)

The project follows Qt for Python's *Sample Bindings* structure and uses the
shiboken generator invoked from CMake.

> ⚠️ This is a starting point. You can gradually expand the typesystem to expose
> more of KTextEditor.

## Build prerequisites

- Python 3.9+ with **PySide6**, **shiboken6**, **shiboken6-generator**
  ```bash
  pip install pyside6 shiboken6 shiboken6-generator
  ```
- Qt 6 (matching your PySide6)
- KDE Frameworks 6 packages for **KTextEditor** and deps (e.g. `kf6-ktexteditor`, `kf6-ktexteditor-devel`)
- CMake ≥ 3.18 and a C++17 compiler
- Ninja (recommended)

### Example package names

**Arch Linux**
```bash
sudo pacman -S ktexteditor qt6-base python-pyside6 shiboken6 shiboken6-generator cmake ninja
```

**Ubuntu (24.04+ based)** – names may vary; you might need KDE Frameworks 6 PPA or to build via `kdesrc-build`.
```bash
sudo apt install qt6-base-dev cmake ninja-build python3-pip
pip install pyside6 shiboken6 shiboken6-generator
# Install KF6 KTextEditor dev packages via your distro or build from source.
```

If your distro doesn't ship KF6 dev packages yet, consider using `kdesrc-build` to fetch & build KF6,
or the distro's `kf6-ktexteditor-devel` equivalents.

## Configure & build

```bash
cd ktexteditor-pyside6-binding
mkdir build && cd build
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release
ninja
ninja install
```

This will place the built Python module next to the sources (for convenience).

## Try it

```bash
python examples/minimal_view.py
```

A window should show a KTextEditor view with some text.

## Extend the bindings

Edit `bindings.xml` to add more classes, enums, or function tweaks.
Shiboken will generate wrappers for **all** methods of classes you list, unless modified.
