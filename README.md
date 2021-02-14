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

XPM aims to solve the following problems:

- Auto-install dependencies in your scripts, regardless of OS

- Installing the correct versions of dependencies, which are often out-of-date or
  poorly configured by default, such as `docker` and `npm`.

It currently supports **Linux** and **MacOS**.

## How do I use it?

1. Install xpm if it's not installed already:

```bash
&>/dev/null xpm v || (curl -SsLo- 'xpm.sh/get' | bash)
```

2. Install whatever you need:

```bash

```

3. Start using those dependencies!

## Is it Docker-friendly?

Yes! You can use XPM to simplify your Dockerfiles.

Instead of arcane install recipes like this:

```dockerfile
RUN cd $(mktemp -d) && wget https://download.bar.io/release/latest/bar.tar.gz && \
    tar xvf bar.tar.gz && cp bar /usr/local/bin/bar` && rm -rf $(pwd) && cd -
```

Use xpm to install these deps for you!

```dockerfile
RUN &>/dev/null xpm v || (curl -SsLo- 'xpm.sh/get' | bash)
RUN xpm install -y bar
```

## Project status

This project is currently in **alpha**. Please feel free to file issues with any feedback or feature requests you might have!
