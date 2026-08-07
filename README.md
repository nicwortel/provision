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

### Phars

The phars phive installed are not covered by any of these.
`phive update` and `phive outdated` read a project's `phive.xml`, which a `--global` install never writes,
so both ignore them.
List what is installed with `sudo phive status --global`, then move a phar to a newer version by reinstalling it
with the key fingerprint from `roles/php/defaults/main.yaml`:

```bash
sudo phive install --global --trust-gpg-keys <key> <phar>
```
