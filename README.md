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
