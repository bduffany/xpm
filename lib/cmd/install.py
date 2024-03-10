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
    def __init__(self, packages):
        self._packages = packages
        self._installed = set()
        self._not_installed = set()

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

    def packages_to_install(self, force=False):
        packages = list(self._not_installed)
        if force:
            packages.extend(self._installed)
        # TODO: toposort
        return packages

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

    def _resolve_aliases(self):
        packages = []
        for package in self._packages:
            alias_file_path = f"lib/packages/{package}/alias.txt"
            if os.path.exists(alias_file_path):
                with open(alias_file_path, "r") as f:
                    resolved_package = f.read().strip()
                packages.append(resolved_package)
            else:
                packages.append(package)
        self._packages = packages

    def main(self, no_confirm=False, force=False):
        if self._packages is not None:
            self._resolve_aliases()
            self.add_all(self._packages)

        packages_to_install = self.packages_to_install(force=force)

        if len(self._installed) and not force:
            print("The following packages are already installed:")
            print("  " + ", ".join(sorted(self._installed)))

        if not len(packages_to_install):
            sys.exit(0)

        if self._not_installed:
            print("The following packages will be installed:")
            print("  " + ", ".join(sorted(self._not_installed)))
        if force:
            print("The following packages will be reinstalled:")
            print("  " + ", ".join(sorted(self._installed)))
        if not no_confirm:
            print("OK [Y/n]? ", end="")
            response = input()
            if response and not re.match(r"^y(es)?$", response.lower().strip()):
                sys.exit(1)

        if force:
            self._installed = set()
        for dep in packages_to_install:
            print(f"Installing {dep}...")
            self.install(dep, no_confirm=no_confirm)
            print(f"Successfully installed {dep}")


@functools.lru_cache(maxsize=None)
def is_installed(dep: str):
    # Run is_installed.sh if it's implemented.
    is_installed_script = f"lib/packages/{dep}/is_installed.sh"
    if os.path.exists(is_installed_script):
        p = subprocess.run(
            ["bash", is_installed_script], check=False, stdout=subprocess.DEVNULL
        )
        return p.returncode == 0
    # For now, fall back to a simple command -v check.
    return sh(f"command -v {dep}").returncode == 0


@functools.lru_cache(maxsize=None)
def direct_deps(package: str):
    deps_file = f"lib/packages/{package}/deps.txt"
    if os.path.exists(deps_file):
        with open(deps_file, "r") as f:
            return [line.strip() for line in f.readlines() if line.strip()]
    return []


def bash_script(*args):
    return f"""bash -c 'set -eo pipefail && {" && ".join(args)}'"""


def install_package(package: str, no_confirm=False):
    install_script = f"lib/packages/{package}/install.sh"
    if os.path.exists(install_script):
        p = subprocess.run(
            bash_script(
                "cd $(mktemp -d)",
                'WORKDIR="$PWD"',
                'function cleanup() { rm -rf "$WORKDIR"; }',
                "trap cleanup EXIT",
                f'export _XPM_NOCONFIRM={"true" if no_confirm else "false"}',
                f'eval "$(xpm source "{install_script}")"',
            ),
            shell=True,
            check=False,
        )
        if p.returncode != 0:
            print("xpm: failed to install " + package, file=sys.stderr)
            exit(1)
    else:
        # Try running the platform's package manager.
        subprocess.run(
            bash_script(
                'eval "$(xpm source lib/platform/package_manager.sh)"',
                f'export _XPM_NOCONFIRM={"true" if no_confirm else "false"}',
                f'xpm::platform::package_manager::install "{package}"',
            ),
            shell=True,
            check=True,
        )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="xpm install")
    parser.add_argument("packages", nargs="+", help="packages to install")
    parser.add_argument(
        "-y", "--yes", action="store_true", help="install without prompting"
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="force install, including all deps",
    )
    args = parser.parse_args()

    try:
        Installer(args.packages).main(no_confirm=args.yes, force=args.force)
    except KeyboardInterrupt:
        print()
        exit(1)
