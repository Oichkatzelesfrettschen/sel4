#!/usr/bin/env bash
# Setup script for seL4 development environment.
# Installs required system and Python packages so tools like kernel_pylint.sh work.
set -euo pipefail

apt_packages=(
	python3-pip
	python3-yaml
	python3-jinja2
	python3-lxml
	python3-ply
	python3-psutil
	python3-bs4
	python3-pyelftools
	python3-sh
	python3-pexpect
	python3-jsonschema
	python3-cffi
	python3-sphinx
	doxygen
	graphviz
	tree
	ocaml
	lua5.4
	perl
	libarchive-dev
	pylint
)

apt-get update
apt-get install -y "${apt_packages[@]}"

pip install --break-system-packages \
	guardonce \
	autopep8==2.3.1 \
	cmake-format==0.4.5 \
	libarchive-c \
	pyfdt \
	future \
	sphinx \
	breathe
