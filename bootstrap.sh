#!/usr/bin/env bash
# Rebuild this setup on a fresh Arch install.
#
# From a bare TTY after the base install (network up via nmcli / iwctl):
#
#   sudo pacman -S --needed git chezmoi
#   chezmoi init https://github.com/mir2x/dotfiles.git    # clone only, no apply yet
#   ~/.local/share/chezmoi/bootstrap.sh
#
# Detects NVIDIA / Intel / AMD hardware and installs the matching package lists,
# then applies the dotfiles. Safe to re-run (everything uses --needed).
set -euo pipefail

[ "$(id -u)" -ne 0 ] || { echo "Run as your normal user, not root." >&2; exit 1; }

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pk="$here/packages"

# Print a package list without comments / blank lines.
list() { grep -vE '^\s*(#|$)' "$1"; }

echo "==> Base tools (+ rustup to build paru, pciutils for lspci)"
sudo pacman -Syu --needed --noconfirm git base-devel rustup pciutils chezmoi age github-cli

# Rust toolchain via rustup, before paru (paru is built with cargo).
echo "==> Rust toolchain (rustup)"
rustup default stable

# paru next, before anything else. Built from source (the -bin package breaks
# whenever pacman's libalpm moves), after the -Syu above so it links against
# the current libalpm.
if ! command -v paru >/dev/null; then
    echo "==> Building paru from source"
    tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/paru.git "$tmp/paru"
    (cd "$tmp/paru" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

echo "==> Detecting hardware"
gpu="$(lspci 2>/dev/null | grep -iE 'vga|3d|display' || true)"
extra=()
grep -qi nvidia <<<"$gpu"          && { echo "  NVIDIA GPU";  extra+=("$pk/nvidia.txt"); }
grep -qiE 'intel' <<<"$gpu"        && { echo "  Intel GPU";   extra+=("$pk/intel-gpu.txt"); }
grep -qiE 'amd|radeon|ati ' <<<"$gpu" && { echo "  AMD GPU";  extra+=("$pk/amd-gpu.txt"); }

ucode=""
case "$(grep -m1 vendor_id /proc/cpuinfo)" in
    *GenuineIntel*) ucode=intel-ucode ;;
    *AuthenticAMD*) ucode=amd-ucode ;;
esac
[ -n "$ucode" ] && echo "  CPU microcode: $ucode"

echo "==> Official packages"
{ list "$pk/common.txt"; for f in "${extra[@]}"; do list "$f"; done; if [ -n "$ucode" ]; then echo "$ucode"; fi; } \
    | sort -u | sudo pacman -S --needed --noconfirm -

echo "==> AUR packages"
list "$pk/aur.txt" | paru -S --needed --noconfirm -

echo "==> Services"
sudo systemctl enable --now NetworkManager bluetooth tailscaled
grep -qi nvidia <<<"$gpu" && sudo systemctl enable nvidia-suspend nvidia-resume nvidia-hibernate || true

echo "==> Dotfiles"
# --force: this is a fresh install, and apps (fcitx5, xdg-user-dirs, ...) may have
# already rewritten their own config, which would otherwise trigger an overwrite prompt.
chezmoi apply -v --force
fc-cache -f   # pick up the Lilex fonts that chezmoi just downloaded

echo "==> dwl (build and install from ~/.local/share/applications/dwl-custom)"
dwl_src="$HOME/.local/share/applications/dwl-custom"
rm -f "$dwl_src/config.h"   # regenerate from config.def.h
make -C "$dwl_src" clean all
sudo make -C "$dwl_src" install

echo
echo "Done. Start the desktop from a TTY with: start-dwl"
echo "Next, by hand: set fish as the login shell (chsh -s /usr/bin/fish),"
echo "restore your browser profiles from backup, run 'tailscale up',"
echo "and put your Claude Code token in CLAUDE_CODE_OAUTH_TOKEN. Then reboot."
