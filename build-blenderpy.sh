#!/bin/bash
#
# Vagrant provisioning script.
#
# Build Blender as Python module
# https://wiki.blender.org/index.php/User:Ideasman42/BlenderAsPyModule
#

set -e

BLENDER_GIT_REPO="https://git.blender.org/blender.git"
BLENDER_VERSION=2.79
PYTHON=python3
PYTHON_INSTALL_PREFIX="/vagrant/pip_package"

# Download sources
if [ ! -e "$HOME/blender" ]; then
  git clone "$BLENDER_GIT_REPO" "$HOME/blender" -b "v$BLENDER_VERSION"
  cd "$HOME/blender"
  git submodule update --init --recursive
else
  cd "$HOME/blender"
fi

# Install dependencies
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated build-essential cmake
./build_files/build_environment/install_deps.sh --no-confirm
# Install build pip package dependencies
sudo apt-get install -y --allow-unauthenticated ${PYTHON}-setuptools ${PYTHON}-wheel

# Build Blender
BLENDER_BUILD_COMMAND="$(tail -n1 BUILD_NOTES.txt)"
eval "$BLENDER_BUILD_COMMAND\"\
  -D WITH_PYTHON_INSTALL=OFF \
  -D WITH_PLAYER=OFF \
  -D WITH_PYTHON_MODULE=ON \
  -D WITH_INSTALL_PORTABLE=ON \
  -D CMAKE_INSTALL_PREFIX=$PYTHON_INSTALL_PREFIX \
\""

# Build pip package
cd build_linux && make install
cd "$PYTHON_INSTALL_PREFIX"
export BLENDER_VERSION
$PYTHON setup.py bdist_wheel
