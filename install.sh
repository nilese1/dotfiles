#!/bin/bash
# install.sh — system setup

# ── colors ──────────────────────────────────────────────────
RESET='\033[0m'
RESET_LINE='\033[2K\r'
DIM='\033[2m'
BGREEN='\033[1;32m'
BCYAN='\033[1;36m'
BYELLOW='\033[1;33m'
BRED='\033[1;31m'
BWHITE='\033[1;37m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

# ── spinner frames (plain ASCII) ─────────────────────────────
SPINNER_FRAMES=('-' '\' '|' '/')

# ── helpers ──────────────────────────────────────────────────
banner() {
    clear
    echo -e "${BCYAN}"
    echo '  +-------------------------------------------------+'
    echo '  |              system setup script                |'
    echo '  +-------------------------------------------------+'
    echo -e "${RESET}"
}

section() {
    echo
    echo -e "  ${BWHITE}:: ${1}${RESET}"
    echo -e "  ${DIM}$(printf -- '-%.0s' {1..50})${RESET}"
}

ok()   { echo -e "  ${BGREEN}[ok]${RESET}    ${1}"; }
skip() { echo -e "  ${BYELLOW}[skip]${RESET}  ${1} — already installed"; }
fail() { echo -e "  ${BRED}[fail]${RESET}  ${1}"; }
info() { echo -e "  ${CYAN}[info]${RESET}  ${1}"; }

spin() {
    local label="$1"
    shift
    local log_file
    log_file=$(mktemp)

    "$@" >"$log_file" 2>&1 &
    local pid=$!
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        local frame="${SPINNER_FRAMES[$((i % ${#SPINNER_FRAMES[@]}))]}"
        printf "${RESET_LINE}  [${BCYAN}%s${RESET}]  %s..." "$frame" "$label"
        sleep 0.1
        ((i++))
    done

    wait "$pid"
    local exit_code=$?
    printf "\r"

    if [[ $exit_code -eq 0 ]]; then
        ok "$label"
    else
        fail "$label (exit $exit_code)"
        echo -e "  ${DIM}$(tail -5 "$log_file")${RESET}"
    fi

    rm -f "$log_file"
    return $exit_code
}

# progress bar — call AFTER the work for each item is done
progress_bar() {
    local current=$1
    local total=$2
    local label=$3
    local bar_width=40
    local filled=$(( current * bar_width / total ))
    local empty=$(( bar_width - filled ))

    local filled_str="" empty_str=""
    [[ $filled -gt 0 ]] && filled_str="$(printf '#%.0s' $(seq 1 $filled))"
    [[ $empty  -gt 0 ]] && empty_str="$(printf '.%.0s' $(seq 1 $empty))"

    printf "${RESET_LINE}  ["
    [[ -n $filled_str ]] && printf "${BGREEN}%s${RESET}" "$filled_str"
    [[ -n $empty_str  ]] && printf "${DIM}%s${RESET}"    "$empty_str"
    printf "]  %d/%d  %s" "$current" "$total" "$label"
    [[ $current -eq $total ]] && echo
}

# ── go time ─────────────────────────────────────────────────
banner

# ── APT PACKAGES ────────────────────────────────────────────
section "APT PACKAGES"

PKGS=(
    i3 lightdm firefox-esr git starship vim flatpak
    gcc python3 pipx xclip picom feh imagemagick
    libx11-dev libxft-dev fastfetch tree-sitter-cli
    ripgrep scrot alacritty polybar rofi htop compton
    playerctl python3-i3ipc pipewire pipewire-pulse
    pavucontrol
)

spin "apt update" sudo apt update -qq

total=${#PKGS[@]}
idx=0
for pkg in "${PKGS[@]}"; do
    sudo apt-get install -y -qq "$pkg" >/dev/null 2>&1
    rc=$?
    ((idx++))
    progress_bar "$idx" "$total" "$pkg"
    [[ $rc -ne 0 ]] && fail "apt could not install: $pkg"
done

ok "APT packages done"

# ── PIPX ─────────────────────────────────────────────────
section "PIPX"
PIPX_PKGS=(
    pywal16 i3-workspace-names-daemon
)

total=${#PIPX_PKGS[@]}
idx=0
for pkg in "${PIPX_PKGS[@]}"; do
    skipped_msg=""
    if pipx list 2>/dev/null | grep "$pkg" -q; then
        skipped_msg="(skipped)"
    else
        pipx install "$pkg"
    fi
    rc=$?
    ((idx++))
    progress_bar "$idx" "$total" "$pkg $skipped_msg"
    [[ $rc -ne 0 ]] && fail "apt could not install: $pkg"
done

ok "PIPX packages done"

# ── RUST ────────────────────────────────────────────────────
section "RUST TOOLCHAIN"

if [[ -d "$HOME/.cargo" ]]; then
    skip "Rust"
else
    spin "Installing Rust via rustup" \
        bash -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
fi

# ── PACSTALL ─────────────────────────────────────────────────
section "PACSTALL"

if [[ -f "/usr/bin/pacstall" ]]; then
    skip "Pacstall"
else
    spin "Installing Pacstall" \
        sudo bash -c "$(wget -q https://pacstall.dev/q/install -O -)"
fi

# ── NEOVIM ───────────────────────────────────────────────────
section "NEOVIM"

if [[ -f "/usr/bin/nvim" ]]; then
    skip "Neovim"
else
    spin "Installing Neovim via Pacstall" pacstall -I neovim
fi

# ── NERD FONTS ───────────────────────────────────────────────
section "NERD FONTS"

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

FONTS=("CascadiaMono" "CascadiaCode" "Noto" "CommitMono")
NERD_FONTS_VER="v3.4.0"
BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VER}"

total=${#FONTS[@]}
idx=0
for font in "${FONTS[@]}"; do
    font_dir="${FONTS_DIR}/${font}"
    if [[ -d "$font_dir" ]]; then
        ((idx++))
        progress_bar "$idx" "$total" "$font (skipped)"
        continue
    fi

    mkdir -p "$font_dir"
    wget -q -P "$font_dir" "${BASE_URL}/${font}.zip" \
        && unzip -q "${font_dir}/${font}.zip" -d "$font_dir" \
        && rm -f "${font_dir}/${font}.zip" \
        || fail "Failed to fetch $font"

    ((idx++))
    progress_bar "$idx" "$total" "$font"
done

spin "Refreshing font cache" fc-cache -fv

# ── TABBED ───────────────────────────────────────────────────
section "TABBED"

if [[ -d "$HOME/.config/tabbed" ]]; then
    spin "Building tabbed" \
        bash -c "cd '$HOME/.config/tabbed' && sudo make clean && sudo make install"
else
    fail "~/.config/tabbed not found — skipping"
fi

# ── CUSTOM SCRIPTS ───────────────────────────────────────────
section "CUSTOM SCRIPTS"

SCRIPTS_DIR="$HOME/.config/scripts"
if [[ -d "$SCRIPTS_DIR" && -f "$SCRIPTS_DIR/configure-path.sh" ]]; then
    cd "$SCRIPTS_DIR"
    sudo chmod +x "$SCRIPTS_DIR/configure-path.sh"
    spin "Running configure-path.sh" sudo "$SCRIPTS_DIR/configure-path.sh"
else
    fail "$SCRIPTS_DIR/configure-path.sh not found — skipping"
fi

# ── DONE ─────────────────────────────────────────────────────
echo
echo -e "  ${BGREEN}All done.${RESET}"
echo
