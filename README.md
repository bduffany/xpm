# XPM: Any software, any platform

XPM is a simple package manager that automates some installation steps on
macOS and Ubuntu/Debian Linux.

It saves some work when installing certain software that is not available
on brew or apt-get. For example, you can just run `xpm install go -f`
to install the latest version of golang, upgrading if it's already
installed.

## How do I use it?

1. Install xpm if it's not installed already:

```bash
xpm v &>/dev/null || (curl -SsL xpm.sh/get | bash)
```

2. Install stuff with `xpm install` or `xpm i` for short:

```bash
xpm i fzf ngrok jq chrome # ...
```

3. Upgrade or reinstall packages with `--force` or `-f`:

```bash
xpm install -f chrome
```

## FAQ

### What's the status of this project?

It's currently in **alpha** and does not come with any guarantees.

### Which packages are supported?

See the package listing in [lib/packages](lib/packages).

If a package is not found there, `xpm` falls back to the installed
package manager (`apt-get`, `brew`, etc.). Also feel free to send pull
requests!
