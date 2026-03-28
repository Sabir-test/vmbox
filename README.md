# vmbox

Virtual Machines management repo.  

This is the single place for everything related to operating, configuring, and
reproducing this virtual machine: AI agent workflows, app setup scripts,
maintenance scripts, architecture plans, and reusable templates.

## Structure

| Directory | Purpose |
|---|---|
| `agents/` | CLI AI agent scripts, system prompts, and MCP configs |
| `apps/` | App installation and configuration scripts |
| `scripts/` | One-off VM maintenance and setup scripts |
| `playbooks/` | Step-by-step runbooks for common VM tasks |
| `plans/` | Architecture and implementation plans |
| `templates/` | Reusable scaffolding templates (devcontainer, etc.) |

## Dotfiles

VM environment dotfiles (shell, editor, git, tools) live separately at:
`~/dotfiles` — managed with GNU Stow, pushed to `Sabir-test/dotfiles`.

Run `~/dotfiles/install.sh` on a fresh VM to reproduce the full environment.

## Dev Workspace

Projects live in `~/dev/`. Each project has its own `.devcontainer/` using the
shared `dev-base:latest` Docker image built from `templates/devcontainer/Dockerfile`.

Scaffold a new project:
```bash
bash ~/dev/vmbox/templates/devcontainer/new-project.sh <project-name>
```

## Related Repos

- `Sabir-test/dotfiles` — VM dotfiles & bootstrap
- `Sabir-test/responio` — Respond.io clone project
- `MBS-Limited/Devops` — DevOps / infra project
