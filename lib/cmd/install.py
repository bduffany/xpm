import argparse
import os
import re
import subprocess
import sys
from typing import List, Set


def sh(command: str, **kwargs):
    return subprocess.run(command, shell=True, encoding="utf-8", capture_output=True)


def direct_deps(package: str):
    deps_file = f"lib/packages/{package}/deps.txt"
    if os.path.exists(deps_file):
        with open(deps_file, "r") as f:
            return [line.strip() for line in f.readlines() if line.strip()]
    return []


def packages_to_install(packages: Set[str] = None) -> Set[str]:
    frontier = set(packages)
    satisfied = set([])
    unsatisfied = set([])
    while len(frontier):
        package = frontier.pop()
        if is_satisfied(package):
            satisfied.add(package)
            continue

        unsatisfied.add(package)
        deps = direct_deps(package)
        for dep in deps:
            if dep not in satisfied and dep not in unsatisfied:
                frontier.add(dep)

    return unsatisfied


def is_satisfied(dep: str):
    # TODO: Handle cases where commands don't necessarily match the package name
    return sh(f"which {dep}").returncode == 0


def bash_script(*args):
    return f"""bash -c 'set -e && {" && ".join(args)}'"""


def install_package(package: str):
    install_script = f"lib/packages/{package}/install.sh"
    if os.path.exists(install_script):
        subprocess.run(
            bash_script(
                "cd $(mktemp -d)",
                'function cleanup() { rm -rf "$PWD"; }',
                "trap cleanup EXIT",
                f'eval "$(xpm source "{install_script}")"',
            ),
            shell=True,
            check=True,
        )
    else:
        # Try running the platform's package manager.
        subprocess.run(
            bash_script(
                "set -x",
                'eval "$(xpm source lib/platform/package_manager.sh)"',
                f'xpm::platform::package_manager::install "{package}"',
            ),
            shell=True,
            check=True,
        )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("packages", nargs="+", help="packages to install")
    parser.add_argument(
        "-y", "--yes", action="store_true", help="install without prompting"
    )
    args = parser.parse_args()

    initial_deps = set(args.packages)
    unsatisfied_deps = packages_to_install(initial_deps)
    print("xpm: will install the following packages:")
    print("  " + ", ".join(unsatisfied_deps))
    if not args.yes:
        print("OK [Y/n]? ", end="")
        response = input()
        if response and not re.match(r"^y(es)?$", response.lower().strip()):
            sys.exit(1)
    for package in unsatisfied_deps:
        install_package(package)
