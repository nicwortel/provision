# Development machine provisioning

Ansible playbook for Ubuntu 26.04.
Dotfiles live in [a separate repository](https://github.com/nicwortel/dotfiles),
which the playbook clones but does not apply.

## Usage

Install the playbook's own dependencies once, as root:

```bash
sudo ./install-dependencies.sh
```

Then provision the machine, where `-K` prompts for the sudo password:

```bash
ansible-playbook -K provision.yaml
```

`provision.yaml` lists the roles that are applied and the versions they install.

Finally, link the dotfiles into `$HOME`, following the [install instructions](https://github.com/nicwortel/dotfiles#install)
in the `~/projects/dotfiles` clone that the playbook has made.
Then log out and back in, so that the `PATH` additions apply.

Run the playbook before linking the dotfiles, not after.
`.profile` only adds `~/.local/bin` to `PATH` if that directory exists at login, and the php role is what creates it.

## Installation methods

Which mechanism a tool uses depends on whether it has to exist to the operating system:

| Manager                       | Used for                                                                                       | Examples                     |
|-------------------------------|------------------------------------------------------------------------------------------------|------------------------------|
| apt                           | Software with a daemon, a desktop entry or system libraries, and ordinary distro packages      | docker, php, code            |
| [mise](https://mise.jdx.dev/) | Standalone CLI binaries                                                                        | kubeconform, opa, trufflehog |
| phive                         | PHP phars, which need an interpreter and which phive signature-checks against the author's key | psalm, phpmd                 |

The playbook installs mise itself, but the tool list lives in the dotfiles, so adding a tool is an edit and a
`mise install` rather than a playbook run.

Trivy is the exception: a standalone binary that stays on apt, because of its stronger signature verification.

## Keeping up to date

Each installation method updates separately:

| Tool     | Command                               | Updates                                                                                             |
|----------|---------------------------------------|-----------------------------------------------------------------------------------------------------|
| apt      | `sudo apt update && sudo apt upgrade` | Distro packages, including ansible, ansible-lint, mise, docker, php and VS Code                     |
| mise     | `mise upgrade`                        | The CLI tools listed in the dotfiles, within the ranges in `config.toml`. `--bump` moves the ranges |
| Composer | `composer self-update`                | `~/.local/bin/composer`                                                                             |
| phive    | `sudo phive selfupdate`               | `/usr/local/bin/phive` itself                                                                       |
| phive    | `sudo phive update --global`          | The global phars, within the constraint each was installed with. Also run by the playbook           |

### Phars

A `--global` install records its constraint in `/root/.phive/global.xml`, which `phive update --global` reads.
Without an explicit constraint, phive records `^` of the installed version, so updates stay within that major
version (or minor version, below 1.0).
`sudo phive status --global` lists what is installed; `phive outdated` has no `--global` option.

To move to a new major version, reinstall with the key fingerprint from `roles/php/defaults/main.yaml`.

```bash
sudo phive install --global --trust-gpg-keys <key> <phar>@^3.0
```

`phive update` cannot be told to trust a key, so a phar signed with a new key fails the playbook run.
Verify the key, accept it in an interactive `sudo phive update --global`, and update the fingerprint.
