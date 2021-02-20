import argparse
import sys
from typing import List


def sort_versions(versions: List[str]) -> List[str]:
    component_lists = [
        [int(part) for part in version.split(".")] for version in versions
    ]
    component_lists.sort()
    return [
        ".".join([str(component) for component in components])
        for components in component_lists
    ]


def _sort_cmd(args):
    versions = sort_versions(args.version)
    for version in versions:
        print(version)


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command")

    sort_parser = subparsers.add_parser(
        "sort", help="Sort semvers passed as args and print them on stdout line by line"
    )
    sort_parser.add_argument(
        "version",
        nargs="*",
        help="semver in the list to be sorted",
    )

    args = parser.parse_args()

    cmd = {
        "sort": _sort_cmd,
    }.get(args.command)
    if cmd is None:
        parser.print_usage(sys.stderr)
        parser.exit(1)

    cmd(args)


if __name__ == "__main__":
    main()