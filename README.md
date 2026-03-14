# Macintosh Setup Playbook

## Setup

Clone the repository and run the initialization script. It will install all prerequisites (Xcode CLI tools, Poetry, Ansible, and Galaxy roles).

```shell
git clone https://github.com/aszwajkowski/mac-setup-playbook.git
cd mac-setup-playbook
./initialize.sh
```

## Run

Applies all configurations defined in the playbook to your machine. You will be prompted for your macOS account password.

```shell
poetry run ansible-playbook main.yml --ask-become-pass
```

> **Tip:** Add `--check --diff` for a dry run — no changes will be applied.

## Update roles

Ansible Galaxy roles and collections are external dependencies. Re-run this command periodically or whenever you pull changes to ensure everything is up to date.

```shell
poetry run ansible-galaxy install -r requirements.yml
```
