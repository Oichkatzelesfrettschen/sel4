#!/usr/bin/env bash
#
# Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
#
# SPDX-License-Identifier: BSD-2-Clause
#

set -euxo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT_DIR=$(dirname "$SCRIPT_DIR")

python_sources=$(find "$ROOT_DIR/tools" "$ROOT_DIR/manual/tools" "$ROOT_DIR/libsel4/tools" -name '*.py')

if [ -z "$python_sources" ]; then
    echo "Unable to find python source files"
    exit 1
fi

pylintrc="$ROOT_DIR/tools/pylintrc"
if [ ! -f "$pylintrc" ]; then
    echo "Unable to find pylintrc"
    exit 1
fi

export PYTHONPATH="$ROOT_DIR/tools:$ROOT_DIR/libsel4/tools:$ROOT_DIR/manual/tools:${PYTHONPATH:-}"
SITE_PACKAGES=$(python3 -c 'import site; print(" ".join(site.getsitepackages()))')
export PYTHONPATH="$PYTHONPATH:$SITE_PACKAGES"

pylint --errors-only --verbose --rcfile="${pylintrc}" ${python_sources}
