# Macintosh Setup Playbook

## Initialization

### Option 1) Script

1. Run [`./initialize.sh`](./initialize.sh) script in the terminal
   ```shell
   ./initialize.sh
   ```

### Option 2) Step-by-step manual commands

1. Ensure [Apple's Command Line Tools](https://developer.apple.com/xcode/features/) are installed
   ```shell
   xcode-select --install
   ```
2. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)

    1. Add Python 3 to PATH
   ```shell
   export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"
   ```
    2. Upgrade Pip
   ```shell
   sudo pip3 install --upgrade pip
   ```
    3. Install Ansible
   ```shell
   pip3 install ansible
   ```

3. Clone or download this repository to your local drive
   ```shell
   git clone https://github.com/aszwajkowski/mac-setup-playbook.git
   ```
4. Install required Ansible roles
   ```shell
   cd mac-setup-playbook
   ansible-galaxy install -r requirements.yml
   ```
5. Install all tasks from the playbook (add `--check --diff` at the end for dry-run). Enter your macOS account password when prompted for the 'BECOME' password
   ```shell
   ansible-playbook main.yml --ask-become-pass
   ```

> **Note**  
> If some Homebrew commands fail, you might need to agree to Xcode's license or fix some other Brew issue. Run `brew doctor` to see if this is the case.
