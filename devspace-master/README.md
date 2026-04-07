# devspace

A containerized development workspace on Linux Mint 22.3, fully sandboxed from the personal home directory.
The container runs **Proxmox VE 9.1 / Debian Stable** as its OS, managed by **Podman + Distrobox**.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [What Is and Isn't Isolated](#what-is-and-isnt-isolated)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
- [Daily Workflow](#daily-workflow)
- [SSH Key Management](#ssh-key-management)
- [Antigravity IDE Integration](#antigravity-ide-integration)
- [Container Lifecycle](#container-lifecycle)
- [Git Tracking](#git-tracking)
- [Installed Components](#installed-components)
- [Troubleshooting](#troubleshooting)
- [Security Reminders](#security-reminders)

---

## Overview

| Goal | Solution |
|------|----------|
| Separate dev tools from personal home | `/home/sabir/dev` is the container's entire `~/` |
| Different OS environment | PVE 9.1 (Debian Stable) image, separate `/bin` `/usr` `/etc` |
| Separate SSH keys for dev work | `~/.ssh/id_dev_ed25519` lives only inside the container |
| Two-terminal workflow | `dev` alias drops into container; home terminal stays clean |
| IDE with container-aware tools | Antigravity built-in Dev Containers + Podman socket |
| Change tracking | Git repo at `/home/sabir/dev` tracks all setup and project files |

---

## Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│  Linux Mint 22.3 Host  (personal home: /home/sabir)              │
│                                                                  │
│  Personal terminal ──── regular bash ────────────────────────┐  │
│  (home work, system tasks, Bitwarden, Obsidian)              │  │
│                                                              │  │
│  Antigravity IDE ─── DOCKER_HOST ──→ Podman socket ──────┐  │  │
│        │                        (/run/user/1000/podman/)  │  │  │
│        └──── opens workspace ──→ /home/sabir/dev ─────┐  │  │  │
│                                    (bind mount = ~/   │  │  │  │
│                                     inside container) │  │  │  │
│              ┌────────────────────────────────────────┘  │  │  │
│              ↓                                           │  │  │
│   ┌───────────────────────────────┐                      │  │  │
│   │  devspace container           │◄─────────────────────┘  │  │
│   │  Image: localhost/pve-base    │                         │  │
│   │  OS:    Proxmox VE 9.1        │  Dev terminal ──────────┘  │
│   │         (Debian Stable)       │  `dev` alias enters here   │
│   │                               │                            │
│   │  ~/  ══  /home/sabir/dev      │  Prompt: [DEV devspace]    │
│   │  .ssh/id_dev_ed25519          │  DEVSPACE=1                │
│   │  Language servers (inside)    │                            │
│   └───────────────────────────────┘                            │
│                                                                  │
│  Personal SSH key: /home/sabir/.ssh/id_ed25519  (host only)     │
└──────────────────────────────────────────────────────────────────┘
```

**How it works:**
- Podman runs the container rootlessly (no daemon, no root required)
- Distrobox wraps Podman with `--home /home/sabir/dev`, making that directory the container's home — and only that directory
- The container has its own `/bin`, `/usr`, `/lib`, `/etc` from the PVE/Debian image
- The host's personal `~` (`/home/sabir`) is not exposed inside the container

---

## What Is and Isn't Isolated

### IS isolated
- **Home directory**: container `~/` = `/home/sabir/dev` only. Host personal files not visible.
- **SSH keys**: dev key lives only in `/home/sabir/dev/.ssh/`. Personal `id_ed25519` is unreachable (protected by `700` permissions on the host's `~/.ssh`).
- **Packages**: `apt install` inside the container does not touch host packages.
- **Shell environment**: `PATH`, aliases, exports inside the container do not leak to the host session.
- **OS userland**: container uses PVE/Debian's `/usr`, `/bin`, `/lib` — completely separate from Mint's.

### Is NOT isolated
- **Kernel**: shared with the host. This is a namespace sandbox, not a VM.
- **Network**: container shares the host network by default. No firewall between them.
- **`/tmp`**: Distrobox mounts the host's `/tmp` into the container.
- **Processes**: host processes may be visible via `/proc` inside the container.

**Mental model:** *"My dev tools, packages, and SSH keys don't pollute my personal home."*
This is appropriate isolation for a personal developer machine. It is not a security jail.

---

## Directory Structure

```
/home/sabir/dev/              ← container's home (~/  inside devspace)
│
├── .bashrc                   ← container shell config: [DEV devspace] prompt, DEVSPACE=1
├── .profile                  ← sources .bashrc for login shells
├── .bash_history             ← container shell history (separate from host)
│
├── .ssh/
│   ├── config                ← enforces id_dev_ed25519 for all SSH/git ops
│   ├── id_dev_ed25519        ← dev private key (generate on first entry — see below)
│   └── id_dev_ed25519.pub    ← dev public key (add to GitHub/GitLab)
│
├── .config/                  ← app configs inside container
├── .local/bin/               ← user-installed binaries inside container
│
├── .devcontainer/
│   └── devcontainer.json     ← Antigravity Dev Containers config (PVE image)
│
├── .git/                     ← git repo tracking this workspace
├── .gitignore                ← ignores .bash_history and secrets
│
├── README.md                 ← this file
└── projects/                 ← your code lives here
```

---

## Getting Started

### Prerequisites (already done)
- Podman 4.9.3 installed
- Distrobox 1.7.0 installed
- PVE base image imported: `localhost/pve-base:latest` (713MB)
- `devspace` container created
- `dev` alias and `DOCKER_HOST` added to `/home/sabir/.bashrc`

### First-time initialization

Open a new terminal and run:

```bash
source ~/.bashrc
dev
```

The first entry takes **1–3 minutes** — Distrobox installs its internals into the container.
When you see the cyan `[DEV devspace]` prompt, you're inside the container on PVE/Debian.

### Generate your dev SSH key (inside the container, first time only)

```bash
# You should now be at the [DEV devspace] prompt
ssh-keygen -t ed25519 -C "sabir-dev-$(date +%Y%m%d)" -f ~/.ssh/id_dev_ed25519
chmod 600 ~/.ssh/id_dev_ed25519

# Print the public key — paste this into GitHub → Settings → SSH keys
cat ~/.ssh/id_dev_ed25519.pub

# Test the connection
ssh -T git@github.com
# Expected: "Hi sabir! You've successfully authenticated..."
```

Store the passphrase in **Bitwarden** (already installed on your system).

---

## Daily Workflow

| Task | Command |
|------|---------|
| Enter dev container | `dev` (in any host terminal) |
| Leave container | `exit` |
| Open IDE with workspace | `antigravity /home/sabir/dev` (from terminal) |
| Check which environment you're in | Look at the prompt — `[DEV devspace]` = inside container |
| Check via script | `echo $DEVSPACE` → `1` inside container, empty outside |

### Two-terminal pattern

```
Terminal A (home)          Terminal B (dev)
─────────────────          ──────────────────────────────
sabir@host:~$              sabir@host:~$ dev
Personal files             [DEV devspace] sabir@host:~/projects$
System updates             git clone, npm install, go build...
Bitwarden, Obsidian        Language servers running inside PVE
```

No tmux required — two terminal tabs or windows is enough. Install tmux inside the container later if you want multiple panes in the dev context (`sudo apt install tmux` inside devspace).

---

## SSH Key Management

| Key | Location | Used for |
|-----|----------|----------|
| `id_ed25519` | `/home/sabir/.ssh/` (host only) | Personal GitHub, system SSH |
| `id_dev_ed25519` | `/home/sabir/dev/.ssh/` (container only) | Dev GitHub/GitLab, project repos |

The SSH config at `~/.ssh/config` (inside the container) enforces `IdentitiesOnly yes` — git and SSH commands inside the container will **never** fall back to the personal key or any agent-forwarded key.

The `GIT_SSH_COMMAND` environment variable in `.bashrc` reinforces this for all git operations.

### Adding a new remote host (inside container)

Add an entry to `/home/sabir/dev/.ssh/config`:

```
Host your.server.com
    HostName your.server.com
    User youruser
    IdentityFile ~/.ssh/id_dev_ed25519
    IdentitiesOnly yes
```

---

## Antigravity IDE Integration

Antigravity v1.107.0 has a built-in **Remote - Dev Containers** extension. The workspace is configured for two modes:

### Mode 1 — Integrated terminal (default, always works)

Every terminal opened inside Antigravity automatically enters the devspace container.

To use: open Antigravity from the terminal (not the app menu):
```bash
antigravity /home/sabir/dev
```
Open a terminal inside Antigravity (`` Ctrl+` ``). You should see `[DEV devspace]` immediately.

### Mode 2 — Full Dev Container (language servers run inside PVE)

Uses the Podman socket + `.devcontainer/devcontainer.json`.

**Requirement:** Always launch Antigravity from the terminal so `DOCKER_HOST` is inherited:
```bash
source ~/.bashrc   # ensures DOCKER_HOST is set
antigravity /home/sabir/dev
```

Then: `Ctrl+Shift+P` → **"Dev Containers: Reopen in Container"**

Antigravity connects to the PVE container via the Podman socket. Language servers (Python LSP, gopls, jdtls, ruby-lsp) run inside the container. The `postCreateCommand` in `devcontainer.json` installs them automatically on first open.

### Settings file

Antigravity user settings: `/home/sabir/.config/Antigravity/User/settings.json`

Current config:
- Default terminal profile set to `devspace (PVE)` → auto-enters container
- `dev.containers.dockerPath` set to `podman`

---

## Container Lifecycle

```bash
# Enter (auto-starts if stopped)
dev

# Leave (container keeps running in background)
exit

# Check status
distrobox list
podman ps -a --filter name=devspace

# Stop the container (free up RAM)
distrobox stop devspace

# Start without entering
distrobox start devspace

# Completely delete and recreate (destroys all installed packages inside)
distrobox rm devspace
distrobox create --name devspace --image localhost/pve-base:latest --home /home/sabir/dev --no-entry --additional-flags "--userns=keep-id"
```

**Note:** Deleting the container does NOT delete your files in `/home/sabir/dev` — those are on the host filesystem. Only packages installed with `apt` inside the container are lost. Your dotfiles, `.ssh` keys, and code in `projects/` survive.

### Rebuild the PVE image (if needed)

If the ISO is still mounted at `/media/sabir/PVE`:

```bash
# Re-extract and re-import
rm -rf /tmp/pve-rootfs
unsquashfs -d /tmp/pve-rootfs /media/sabir/PVE/pve-base.squashfs
tar -C /tmp/pve-rootfs -c . | podman import - pve-base:latest
```

---

## Git Tracking

This directory is a git repository. All workspace setup changes are tracked.

```bash
# View history
git log --oneline

# See current changes
git status
git diff

# Commit new config changes
git add <file>
git commit -m "config: describe what you changed"
```

**What to commit:** dotfiles, configs, `devcontainer.json`, scripts, `projects/` code.

**What NOT to commit:** SSH private keys, `.env` files with secrets, large binaries.

The `.gitignore` currently excludes `.bash_history`. Add secrets patterns as needed:

```bash
echo ".env" >> .gitignore
echo "*.key" >> .gitignore
git add .gitignore && git commit -m "gitignore: add secrets patterns"
```

---

## Installed Components

| Component | Version | Location |
|-----------|---------|----------|
| Podman | 4.9.3 | `/usr/bin/podman` (host) |
| Distrobox | 1.7.0 | `/usr/bin/distrobox` (host) |
| Container image | pve-base:latest (713MB) | Podman local store |
| Container name | devspace | Distrobox |
| Base OS in container | Proxmox VE 9.1 / Debian Stable | — |
| Antigravity IDE | 1.107.0 | `/usr/bin/antigravity` (host) |
| Podman user socket | active | `/run/user/1000/podman/podman.sock` |

---

## Troubleshooting

**Container fails to start:**
```bash
podman ps -a --filter name=devspace   # check state
podman logs devspace                   # check errors
distrobox rm devspace && distrobox create ...  # recreate if corrupted
```

**`dev` alias not found:**
```bash
source ~/.bashrc   # reload host shell config
type dev           # verify alias exists
```

**Antigravity terminal doesn't enter container:**
- Make sure you launched Antigravity from a terminal (`antigravity /home/sabir/dev`), not the app menu
- Check `echo $DOCKER_HOST` in the Antigravity terminal — should show the Podman socket path

**Podman socket not found:**
```bash
systemctl --user status podman.socket
systemctl --user enable --now podman.socket
ls /run/user/$(id -u)/podman/podman.sock
```

**SSH key permission errors:**
```bash
chmod 700 ~/.ssh             # inside container
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_dev_ed25519
```

**`unsquashfs` to rebuild image (ISO must be mounted):**
```bash
ls /media/sabir/PVE/pve-base.squashfs   # verify ISO still mounted
```
If not mounted: open Files, navigate to `~/Downloads`, double-click `proxmox-ve_9.1-1.iso`.

---

## Security Reminders

- **Change your sudo password:** `passwd`
- Never commit SSH private keys (`id_dev_ed25519`) to git
- The dev SSH key (`id_dev_ed25519`) is only for dev work — keep it separate from the personal key
- Store all passphrases in **Bitwarden** (installed on your system)
- The container shares the host network — do not run untrusted servers that bind to `0.0.0.0` inside the container
