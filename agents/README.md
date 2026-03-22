# agents/

CLI AI agent workflows for managing this VM.

## Structure

```
agents/
├── prompts/    ← System prompts and task prompts for Claude, Gemini, etc.
└── mcp/        ← MCP server configs (to be added)
```

## Usage

Run agents from this directory or any project directory using the installed
`claude`, `gemini`, or `cursor` CLI tools.

Agent context: always read `CLAUDE.md` at the repo root and
`/home/mbs/.agent/AGENT_VM.md` for VM-specific rules.
