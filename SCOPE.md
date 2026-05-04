# Scope: sandboxed-devspace — VM Daily Operations (vmbox)

**Everything for operating, configuring, and reproducing the sandbox VM.**

## What belongs here

| Directory | Contents |
|---|---|
| `agents/` | AI agent scripts, system prompts, MCP configs |
| `apps/` | App installation and configuration scripts |
| `scripts/` | One-off VM maintenance and setup scripts |
| `playbooks/` | Step-by-step runbooks for common VM tasks |
| `plans/` | Architecture and implementation plans |
| `templates/` | Reusable scaffolding (devcontainer, new-project) |
| `devspace-master/` | Core devspace configuration |

## What does NOT belong here

| Content type | Where it lives |
|---|---|
| Hardware / hypervisor configs | [`home-template`](https://github.com/Sabir-test/home-template) |
| Docker Compose service stacks | `home-template/services/` |
| Shell / CLI tool configs | [`dotfiles`](https://github.com/Sabir-test/dotfiles) |
| Dev environment template | [`workspace`](https://github.com/Sabir-test/workspace) |

## Bootstrap a fresh VM

```bash
# 1. Install dotfiles
git clone https://github.com/Sabir-test/dotfiles.git ~/dotfiles
~/dotfiles/install.sh

# 2. Clone this repo
git clone https://github.com/Sabir-test/Sandboxed-devspace.git ~/dev/vmbox

# 3. Scaffold a new project
bash ~/dev/vmbox/templates/devcontainer/new-project.sh <project-name>
```

## Related repos

- [`dotfiles`](https://github.com/Sabir-test/dotfiles) — VM dotfiles & bootstrap
- [`home-template`](https://github.com/Sabir-test/home-template) — Homelab infrastructure
- [`workspace`](https://github.com/Sabir-test/workspace) — OpenCodeSpace dev template
