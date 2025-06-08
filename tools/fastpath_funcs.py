#!/usr/bin/env python3
"""List fastpath function locations in the seL4 source tree."""

from __future__ import annotations

import argparse
from pathlib import Path
import re

# Match C function definitions that start with ``fastpath_``
FUNC_RE = re.compile(r"^\w.*\b(fastpath_\w+)\s*\(")


def find_fastpath_functions(source: Path) -> list[tuple[str, int]]:
    """Return (function_name, line_number) pairs found in *source*.

    Duplicate function names are ignored so each name appears once.
    """

    functions: list[tuple[str, int]] = []  # collected results
    seen: set[str] = set()  # track names already reported

    # Read the file line by line, tracking line numbers for reporting
    with source.open(encoding="utf-8") as file:
        for idx, line in enumerate(file, start=1):
            match = FUNC_RE.search(line)
            if match:
                name = match.group(1)
                if name not in seen:
                    functions.append((name, idx))
                    seen.add(name)

    return functions


def main() -> None:
    """Parse command-line options and print discovered functions."""

    parser = argparse.ArgumentParser(description="List seL4 fastpath functions")
    parser.add_argument(
        "--kernel-root",
        type=Path,
        default=Path("."),
        help="Path to the seL4 kernel source tree",
    )
    args = parser.parse_args()

    # Build path to ``fastpath.c`` relative to the provided kernel root
    source_path = args.kernel_root / "src" / "fastpath" / "fastpath.c"

    for name, line in find_fastpath_functions(source_path):
        print(f"{name} starts at line {line}")


if __name__ == "__main__":
    main()
