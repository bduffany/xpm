import argparse
import os
import re
import subprocess
import sys
import functools
from typing import List, Set


def sh(command: str, **kwargs):
    return subprocess.run(command, shell=True, encoding="utf-8", capture_output=True)


class Installer(object):
    def __init__(self, packages: List[str] = None):
        self._installed = set([])
        self._not_installed = set([])
        if packages is not None:
            self.add_all(packages)

    def is_installed(self, dep: str) -> bool:
        return dep in self._installed

    def install(self, dep: str, stack: List[str] = None, no_confirm=False):
        if self.is_installed(dep):
            return
        if stack is None:
            stack = []
        if dep in stack:
            raise ValueError(
                f'Circular dependency detected: [{"->".join(stack)} -> {dep}]'
            )

        stack.append(dep)

        # install direct deps of package
        for direct_dep in direct_deps(dep):
            self.install(direct_dep, stack=stack, no_confirm=no_confirm)
        # install package
        install_package(dep, no_confirm=no_confirm)
        self._installed.add(dep)

        stack.pop()

    def packages_to_install(self):
        return sorted(self._not_installed)

    def add_all(self, packages: List[str]):
        frontier = set(packages)

        while len(frontier):
            package = frontier.pop()
            if is_installed(package):
                self._installed.add(package)
                continue
            self._not_installed.add(package)
            deps = direct_deps(package)
            for dep in deps:
                if dep not in self._installed and dep not in self._not_installed:
                    frontier.add(dep)

    def main(self, no_confirm=False):
        packages_to_install = self.packages_to_install()

        if not len(packages_to_install):
            sys.exit(0)

        print("xpm: will install the following packages:")
        print("  " + ", ".join(packages_to_install))
        if not no_confirm:
            print("OK [Y/n]? ", end="")
            response = input()
            if response and not re.match(r"^y(es)?$", response.lower().strip()):
                sys.exit(1)

        for dep in self._not_installed:
            self.install(dep, no_confirm=no_confirm)


@functools.lru_cache(maxsize=None)
def is_installed(dep: str):
    # TODO: Handle cases where commands don't necessarily match the package name
    return sh(f"which {dep}").returncode == 0


@functools.lru_cache(maxsize=None)
def direct_deps(package: str):
    deps_file = f"lib/packages/{package}/deps.txt"
    if os.path.exists(deps_file):
        with open(deps_file, "r") as f:
            return [line.strip() for line in f.readlines() if line.strip()]
    return []


def bash_script(*args):
    return f"""bash -c 'set -e && {" && ".join(args)}'"""


def install_package(package: str, no_confirm=False):
    install_script = f"lib/packages/{package}/install.sh"
    if os.path.exists(install_script):
        subprocess.run(
            bash_script(
                "cd $(mktemp -d)",
                'function cleanup() { rm -rf "$PWD"; }',
                "trap cleanup EXIT",
                f'export _XPM_NOCONFIRM={"true" if no_confirm else "false"}',
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
                f'export _XPM_NOCONFIRM={"true" if no_confirm else "false"}',
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
    Installer(args.packages).main(no_confirm=args.yes)
