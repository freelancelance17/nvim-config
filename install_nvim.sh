#!/usr/bin/env bash
#
# Bootstrap this Neovim configuration on a fresh machine.
#
# It installs the external tools the config depends on, backs up any existing
# Neovim config, clones this repo into ~/.config/nvim, and lets lazy.nvim install
# the plugins headlessly.
#
# Primary target is macOS (Homebrew). On Linux it will tell you which packages to
# install with your distro's package manager, then continue with the clone +
# plugin install.
#
# Re-running is safe: every step checks whether the tool already exists first.

set -euo pipefail

NVIM_CONFIG_DIR="$HOME/.config/nvim"
REPO="https://github.com/freelancelance17/nvim-config"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

#######################################################################
#                          External tools                             #
#######################################################################
# What this config needs and why:
#   neovim 0.12+   - config uses 0.12 APIs; nvim-treesitter is on the `main`
#                    branch, which only supports 0.12
#   git            - lazy.nvim clones plugins
#   ripgrep (rg)   - telescope live_grep / grep_string
#   C compiler     - builds tree-sitter parsers and LuaSnip's jsregexp
#   tree-sitter    - REQUIRED: nvim-treesitter `main` builds parsers with the
#                    tree-sitter CLI (the old branch only needed a C compiler)
#   node + npm     - some LSP servers; also the easiest source of the
#                    tree-sitter CLI
#   rustup/cargo   - rust-analyzer + the Rust toolchain (rustaceanvim)
#   python3        - pynvim / debugpy (Python debugging)

install_macos_deps() {
  if ! have brew; then
    warn "Homebrew not found. Install it from https://brew.sh then re-run."
    exit 1
  fi

  info "Installing tools via Homebrew (skips anything already present)"
  for pkg in neovim git ripgrep fd node rustup; do
    if have brew && ! brew list --formula "$pkg" >/dev/null 2>&1; then
      brew install "$pkg" || warn "brew install $pkg failed (continuing)"
    fi
  done

  # The Homebrew `tree-sitter` formula ships only the library, not the CLI the
  # nvim-treesitter `main` branch needs to build parsers — install the CLI via npm.
  if ! have tree-sitter; then
    info "Installing tree-sitter CLI via npm"
    npm install -g tree-sitter-cli
  fi

  # rust-analyzer / Rust toolchain
  if have rustup && ! have rust-analyzer; then
    info "Adding the rust-analyzer rustup component"
    rustup component add rust-analyzer || warn "could not add rust-analyzer (continuing)"
  fi
}

print_linux_deps() {
  warn "Linux detected — install these with your package manager, then re-run:"
  cat <<'EOF'
  - neovim (>= 0.12)
  - git
  - ripgrep
  - a C compiler (build-essential / base-devel) and make
  - nodejs + npm
  - tree-sitter CLI:  npm install -g tree-sitter-cli
  - rustup (https://rustup.rs) then: rustup component add rust-analyzer
  - python3 + pip
EOF
}

case "$(uname -s)" in
  Darwin) install_macos_deps ;;
  Linux)  print_linux_deps ;;
  *)      warn "Unknown OS — install the dependencies listed in the README manually." ;;
esac

#######################################################################
#                       Clone the configuration                       #
#######################################################################
if [[ -d "$NVIM_CONFIG_DIR" ]]; then
  info "Backing up existing config to ${NVIM_CONFIG_DIR}.backup"
  rm -rf "${NVIM_CONFIG_DIR}.backup"
  mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.backup"
fi

info "Cloning config into $NVIM_CONFIG_DIR"
git clone "$REPO" "$NVIM_CONFIG_DIR"

#######################################################################
#                       Install Neovim plugins                        #
#######################################################################
# lazy.nvim bootstraps itself from init.lua, so a single headless run installs
# everything. Treesitter parsers compile in the background via the tree-sitter
# CLI installed above.
if have nvim; then
  info "Installing plugins (lazy.nvim) — this may take a minute"
  nvim --headless "+Lazy! sync" +qa || warn "plugin install reported errors; open nvim and run :Lazy"
else
  warn "nvim not on PATH yet; open a new shell, then run: nvim '+Lazy! sync' +qa"
fi

cat <<'EOF'

Done. A few manual follow-ups inside Neovim:
  - :Mason            install language servers / debug adapters used by the
                      config (e.g. codelldb for Rust/DAP, debugpy for Python,
                      roslyn for C#). See :checkhealth for what's missing.
  - :checkhealth      verify treesitter, LSP, and provider setup.

If anything looks off, your previous config is at ~/.config/nvim.backup
EOF
