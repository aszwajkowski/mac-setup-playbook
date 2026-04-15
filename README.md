# Macintosh Setup Playbook

## Setup

Clone the repository and run the initialization script. It will install all prerequisites (Xcode CLI tools, Poetry, Ansible, and Galaxy roles).

```shell
git clone https://github.com/aszwajkowski/mac-setup-playbook.git
cd mac-setup-playbook
./initialize.sh
```

## Customization

The playbook loads variables from `vars/default.config.yml` first, then overlays anything found in `vars/config.yml` (git-ignored). To customize without editing defaults:

```shell
cp vars/default.config.yml vars/config.yml
# Edit vars/config.yml with your overrides
```

Only the values you set in `config.yml` will override the defaults — you don't need to copy the entire file.

## Run

Applies all configurations defined in the playbook to your machine. You will be prompted for your macOS account password.

```shell
poetry run ansible-playbook main.yml --ask-become-pass
```

> **Tip:** Add `--check --diff` for a dry run — no changes will be applied.

### Tags

Run only specific parts of the playbook with `--tags`:

| Tag          | Description                        |
|--------------|------------------------------------|
| `homebrew`   | Homebrew packages and cask apps    |
| `dock`       | Dock item management               |
| `macos`      | macOS system defaults              |
| `post`       | Post-provision task files          |

```shell
poetry run ansible-playbook main.yml --ask-become-pass --tags homebrew
```

## Update roles

Ansible Galaxy roles and collections are external dependencies. Re-run this command periodically or whenever you pull changes to ensure everything is up to date.

```shell
poetry run ansible-galaxy install -r requirements.yml --force
```
