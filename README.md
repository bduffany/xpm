# XPM: Cross-platform package manager

Does this conversation sound familiar?

> **You**: "Hey, try running `setup_environment.sh` in the repo. It should automate the whole process for you."

> **Friend**: "Hmm, I tried that, but it's failing with `foo: command not found`."

> **You**: "Oh yeah, you'll have to install `foo`. Try installing `foo` on your machine then run the script again."

> **Friend**: "Hmm... now the setup script is trying to run `brew install bar`, but I'm on Linux and I don't have `brew`."

> **You**: "Oh... well, try replacing `brew` with `apt-get` and see if it works."

> **Friend**: Hmm... looks like `apt-get` has a really out of date version of `bar`. Guess I'll try manually installing `bar`.

> **You**: Ouch. Good luck with that...

## XPM to the rescue

XPM aims to be a package manager that "just works."

- You can include it in your bash scripts with **one line of code,**
  then use it to install packages that are required by your scripts,
  _regardless of the OS that the script is being run on_.

- It works around common problems with dependencies, such as outdated
  versions being registered with the OS' package manager (looking at you,
  `docker` and `node`).

- It allows installing packages on the command line that would otherwise require
  manual download and installation, like `ngrok`, `google-chrome`, and `telegram`.

It currently supports **Linux** and **MacOS**.

## How do I use it?

1. Install xpm if it's not installed already:

```bash
xpm v &>/dev/null || (curl -SsLo- 'xpm.sh/get' | bash)
```

2. Install whatever you need:

```bash
xpm install fzf ngrok jq google-chrome # ...
```

3. Start using those dependencies!

## FAQ

### What's the status of this project?

It's currently in **alpha.** Things may break at any time. Some of the documentation
may refer to behavior or features that are unstable or aren't implemented yet.
Use at your own risk!

### Which packages are supported?

See the package listing in [lib/packages](lib/packages).

If a package is not found there, `xpm` falls back to the installed
package manager (`apt-get`, `brew`, etc.)

### Can I use it in a Dockerfile?

Yes! You can use xpm to simplify your Dockerfiles. Instead of arcane install
recipes like this:

```dockerfile
RUN cd $(mktemp -d) && wget https://download.bar.io/release/latest/bar.tar.gz && \
    tar xvf bar.tar.gz && cp bar /usr/local/bin/bar` && rm -rf $(pwd) && cd -
```

You can use xpm to install these deps for you!

```dockerfile
# Install basic deps needed for xpm
RUN apt-get update -y && apt install sudo curl get wget unzip
# Install XPM itself. Pipe "yes" into it to avoid confirmation prompts.
# (Also, see security notes below)
RUN xpm v &>/dev/null || yes | (curl -SsLo- 'xpm.sh/get' | bash)
# Install with -y so confirmation isn't needed.
RUN xpm install -y bar
```

### Is it secure? What are the potential attack surfaces?

- One attack surface is the `xpm.sh/get` endpoint. If something happens to me and I forget to
  renew that domain, someone could snag that domain and point it at a malicious bash script.
  To defend against this kind of attack, run a sha256 checksum on the downloaded script before
  piping it into bash.

- If a malicious actor gains control of my GitHub account, they could replace the setup script
  with something malicious. If you believe that might happen, you could clone this repo and host
  your own version of XPM.

- Other attack surfaces may exist; please file an issue if you think of one!
