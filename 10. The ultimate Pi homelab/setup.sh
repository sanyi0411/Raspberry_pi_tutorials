#!/bin/bash
#
# Homelab setup for a fresh Raspberry Pi 5:
#  - Install Docker + Compose
#  - Create container config directories
#  - Start containers

set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

info() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\n\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

env_get() {
    sed -n -E "s/^$1=//p" .env | tail -n1 | sed -E -e 's/\r$//' -e 's/^"(.*)"$/\1/' -e "s/^'(.*)'\$/\1/"
}

# ---------------------------------------------------------------------------
info "Checking preconditions"

[[ $EUID -ne 0 ]] || die "Run as your normal user, not root or sudo."
command -v sudo >/dev/null || die "sudo is required."

arch=$(uname -m)
[[ $arch == aarch64 ]] || warn "Architecture is $arch, expected aarch64 (64-bit Pi OS). Images are arm64/amd64 multi-arch, so this may still work."

if [[ ! -f .env ]]; then
    [[ -f .env.template ]] || die "Neither .env nor .env.template found in $PWD."
    cp .env.example .env
    info "Created .env from .env.example -- review it before the stack goes live."
fi
chmod 600 .env

puid=$(env_get PUID)
pgid=$(env_get PGID)
[[ -n $puid && -n $pgid ]] || die "PUID/PGID missing from .env."

if [[ $puid != "$(id -u)" || $pgid != "$(id -g)" ]]; then
    warn "PUID/PGID in .env ($puid:$pgid) differ from the current user ($(id -u):$(id -g)). Downloaded files will not be owned by you."
fi

# ---------------------------------------------------------------------------
info "Checking media directories"

missing=0
for var in MOVIES_DIR TVSHOWS_DIR TORRENT_FILES_DIR; do
    dir=$(env_get "$var")
    [[ -n $dir ]] || die "$var is not set in .env."
    if [[ ! -d $dir ]]; then
        warn "$var does not exist: $dir"
        missing=1
        continue
    fi
    printf '    %-18s %s\n' "$var" "$dir"
done
if (( missing )); then
    die "Mount the drives (or create the directories) and re-run. They are deliberately not created here, so an unmounted disk cannot be silently filled with downloads on the SD card."
fi

for var in MOVIES_DIR TVSHOWS_DIR TORRENT_FILES_DIR; do
    dir=$(env_get "$var")
    [[ -w $dir ]] || warn "Not writable by $(id -un): $dir -- qBittorrent will fail to save there. Fix with: sudo chown -R $puid:$pgid \"$dir\""
done

# ---------------------------------------------------------------------------
info "Installing Docker"

if command -v docker >/dev/null; then
    echo "    already installed: $(docker --version)"
else
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    rm -f /tmp/get-docker.sh
fi

docker compose version >/dev/null 2>&1 \
    || die "The 'docker compose' plugin is unavailable. Install it with: sudo apt-get install -y docker-compose-plugin"

sudo systemctl enable --now docker

if ! id -nG "$(id -un)" | tr ' ' '\n' | grep -qx docker; then
    sudo usermod -aG docker "$(id -un)"
    needs_relogin=1
    info "Added $(id -un) to the docker group. Log out and back in to use docker without sudo."
fi

# ---------------------------------------------------------------------------
info "Creating container state directories"

install -d -m 775 -o "$puid" -g "$pgid" \
    config/qbittorrent config/jellyfin cache/jellyfin 2>/dev/null \
    || sudo install -d -m 775 -o "$puid" -g "$pgid" \
        config/qbittorrent config/jellyfin cache/jellyfin
echo "    config/qbittorrent config/jellyfin cache/jellyfin"

# ---------------------------------------------------------------------------
info "Starting the stack"

compose() { if (( ${needs_relogin:-0} )); then sudo -E docker compose "$@"; else docker compose "$@"; fi; }

compose pull
compose up -d
compose ps

# ---------------------------------------------------------------------------
info "qBittorrent first-login password"
sleep 5
if compose logs --since 60s qbittorrent 2>/dev/null | grep -i 'temporary password'; then
    echo "    Log in as 'admin' with the password above, then change it immediately in"
    echo "    Tools > Options > Web UI. The temporary one is regenerated on every restart."
else
    echo "    No temporary password in the logs -- a password is already configured."
fi

info "Done"
qbt_port=$(env_get QBITTORRENT_WEBUI_PORT)
jf_port=$(env_get JELLYFIN_PORT)
echo "    qBittorrent  http://$(hostname -I | awk '{print $1}'):${qbt_port}"
echo "    Jellyfin     http://$(hostname -I | awk '{print $1}'):${jf_port}"
