# Development machine provisioning

Ansible playbook for Ubuntu 26.04.
Dotfiles live in [a separate repository](https://github.com/nicwortel/dotfiles).

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
