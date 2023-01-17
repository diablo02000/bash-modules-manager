# Bash modules manager

## Description

Bash script to easily downlaod and install bash modules.

## Usage

```bash
./bash-modules-manager.sh -u/--url [-v/--version]
```

- url: Git repository url.
- version: Tag from git repository.

## Example

- Get `log4bash` module:

```bash
./bash-modules-manager.sh -u https://github.com/diablo02000/log4bash.git
```

> **_NOTE:_** By default, the tool take the main branch.

- Get the tag `1.0.2` of `log4bash` module:

```bash
./bash-modules-manager.sh -u https://github.com/diablo02000/log4bash.git -v 1.0.2
```

## Configure

By default, the tool store all the module in `${HOME}/.local/lib/bash` directory.
You can overwrite the path by setting `BASH_MODULE_DIR` variable.

```bash
BASH_MODULE_DIR=/opt/bash-module ./bash-modules-manager.sh -u https://github.com/diablo02000/log4bash.git
```
