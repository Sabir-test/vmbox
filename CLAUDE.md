# vmbox — AI Agent Context

This repo manages VM 200 (KDE Neon, Proxmox guest). Read
`/home/mbs/.agent/AGENT_VM.md` for critical VM architecture rules before acting.

## What this repo is for

- `agents/` — Store and run CLI AI agent scripts from here. Prompts go in
  `agents/prompts/`. MCP server configs go in `agents/mcp/`.
- `apps/` — Scripts to install or configure applications on this VM.
  Each script should be idempotent.
- `scripts/` — One-off maintenance scripts (fix Docker network, reset a
  service, etc.). Run manually as needed.
- `playbooks/` — Markdown runbooks. Document procedures here so they can be
  referenced or executed by an agent in future sessions.
- `plans/` — Architecture and design documents for planned work.
- `templates/devcontainer/` — Shared devcontainer base image and scaffolding.
  `new-project.sh <name>` creates a new isolated project under `~/dev/`.

## Key paths

| Path | Purpose |
|---|---|
| `~/dev/vmbox/` | This repo |
| `~/dotfiles/` | Dotfiles (GNU Stow) |
| `~/dev/.workspace/` | Symlink → `vmbox/templates/devcontainer/` |
| `/home/mbs/.agent/AGENT_VM.md` | VM architecture rules (read first) |
| `/home/mbs/HostReports/` | Drop files here for host-side issues |

## Conventions

- App install scripts in `apps/` must be idempotent (safe to run twice)
- Scripts that require sudo must say so in a comment at the top
- Never commit secrets, tokens, or private keys here
