#!/usr/bin/env bash

set -euo pipefail

readonly COLOR_RESET="\033[0m"
readonly COLOR_GREEN="\033[0;32m"
readonly COLOR_YELLOW="\033[0;33m"
readonly COLOR_RED="\033[0;31m"
readonly COLOR_CYAN="\033[0;36m"

log_info()    { printf "${COLOR_CYAN}[INFO]${COLOR_RESET}  %s\n" "$*"; }
log_success() { printf "${COLOR_GREEN}[OK]${COLOR_RESET}    %s\n" "$*"; }
log_warn()    { printf "${COLOR_YELLOW}[WARN]${COLOR_RESET}  %s\n" "$*"; }
log_error()   { printf "${COLOR_RED}[ERROR]${COLOR_RESET} %s\n" "$*" >&2; }

abort_with_line_number() {
  log_error "Script failed at line $1. Aborting."
  exit 1
}

trap 'abort_with_line_number $LINENO' ERR

is_command_available() { command -v "$1" &>/dev/null; }

assert_python3_is_available() {
  if ! is_command_available python3; then
    log_error "python3 not found. Install Python 3 (https://www.python.org/downloads/) and re-run."
    exit 1
  fi
  log_info "Using $(python3 --version 2>&1)"
}

install_xcode_cli_tools() {
  if xcode-select -p &>/dev/null; then
    log_success "Apple Command Line Tools already installed: $(xcode-select -p)"
    return
  fi

  log_info "Installing Apple Command Line Tools..."
  xcode-select --install

  log_info "Waiting for Apple Command Line Tools installation to complete..."
  until xcode-select -p &>/dev/null; do
    sleep 5
  done

  log_success "Apple Command Line Tools installed."
}

install_poetry() {
  if is_command_available poetry; then
    log_success "Poetry already installed: $(poetry --version)"
    return
  fi

  log_info "Installing Poetry via official installer..."
  curl -sSL https://install.python-poetry.org | python3 -

  export PATH="$HOME/.local/bin:$PATH"

  if ! is_command_available poetry; then
    log_error "Poetry installation succeeded but 'poetry' is not on PATH."
    log_error "Add '$HOME/.local/bin' to your PATH and re-run."
    exit 1
  fi

  log_success "Poetry installed: $(poetry --version)"
}

configure_poetry_virtualenv_in_project() {
  log_info "Configuring Poetry to create virtual environments inside the project..."
  poetry config virtualenvs.in-project true
}

install_ansible_via_poetry() {
  log_info "Installing project dependencies via Poetry (includes Ansible)..."
  poetry install --no-root
  log_success "Ansible installed: $(poetry run ansible --version | head -n1)"
}

install_ansible_galaxy_roles() {
  log_info "Installing Ansible Galaxy roles and collections..."
  poetry run ansible-galaxy install -r requirements.yml --force
  log_success "Ansible Galaxy roles and collections installed."
}

print_next_steps() {
  printf "\n"
  log_success "Environment is ready. Run the playbook with:"
  printf "\n"
  printf "  poetry run ansible-playbook main.yml --ask-become-pass\n"
  printf "\n"
  log_info "Tip: add '--check --diff' to ansible-playbook for a dry run."
  printf "\n"
}

main() {
  log_info "Starting mac-setup-playbook bootstrap..."
  assert_python3_is_available
  install_xcode_cli_tools
  install_poetry
  configure_poetry_virtualenv_in_project
  install_ansible_via_poetry
  install_ansible_galaxy_roles
  print_next_steps
}

main
