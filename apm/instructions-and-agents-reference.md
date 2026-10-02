---
type: reference
resource: https://microsoft.github.io/apm/producer/author-primitives/instructions-and-agents/#agents
tags: [apm, instructions, agents, frontmatter, compilation]
generated: 2026-09-30
status: draft
stale_after: null
sources: [inbox/archive/default/2026-09-30T050933-instructions-and-agents.md]
---

# Instructions and agents: frontmatter and compilation targets

APM (Agent Package Manager) compiles two primitive types to
harness-native formats: **instructions** (scope-attached rules) and
**agents** (persona scoping modules).

## Instructions

A unit of policy bound to a glob. File names end in `.instructions.md` and
live under `.apm/instructions/`.

### Frontmatter

```yaml
---
description: Python style rules enforced on src/ and tests/
applyTo: "**/*.py"
---
```

| Key | Required | Purpose |
|---|---|---|
| `description` | yes | One-line summary; used in compiled context indexes |
| `applyTo` | yes for instructions | Glob (or comma-separated globs) the rule binds to |

- Without `applyTo`, an instruction is unconditional and gets folded into
  compiled context files (`AGENTS.md`, `GEMINI.md`) instead of a per-file
  rule directory.
- `applyTo` accepts a single glob or a comma-separated list. Commas inside
  brace alternation (`**/*.{css,scss}`) are part of the glob, not list
  separators — only top-level commas split the list. Escape a literal
  comma in a filename as `\,`.
- A YAML sequence (`applyTo: ["**/*.py"]`) is also accepted; APM normalizes
  multi-pattern sequences into the same comma-separated OR expression used
  by distributed compilation and target-native installation.
- During distributed compilation, an explicitly scoped pattern may match
  files under supported top-level harness directories: `.agents`, `.apm`,
  `.claude`, `.codex`, `.cursor`, `.gemini`, `.github`, `.kiro`,
  `.opencode`, and `.windsurf`. Other hidden directories remain excluded.

### Instruction compilation targets

| Target | Output path | Transform |
|---|---|---|
| copilot | `.github/instructions/<name>.instructions.md` | verbatim; `applyTo` preserved (comma-lists split natively by Copilot) |
| claude | `.claude/rules/<name>.md` | `applyTo` → `paths:` list (comma-lists expanded to YAML array) |
| grok-build | `.grok/rules/<name>.md` and folded into `AGENTS.md` | native rule plus compiled root context |
| cursor | `.cursor/rules/<name>.mdc` | `applyTo` → `globs:` (scalar for single glob, YAML array for comma-lists); description auto-derived if missing |
| windsurf | `.windsurf/rules/<name>.md` | `applyTo` → `trigger: glob` + `globs:` (scalar or YAML array); missing `applyTo` → `trigger: always_on` |
| kiro | `.kiro/steering/<name>.md` | `applyTo` → `inclusion: fileMatch` + `fileMatchPattern:`; missing `applyTo` → `inclusion: always` |
| antigravity | `.agents/rules/<name>.md` | `applyTo` → `trigger: glob` + `globs:` (scalar or YAML array); missing `applyTo` → no frontmatter (unconditional rule) |
| codex | folded into `AGENTS.md` | compile-only, no per-file deploy |
| gemini | folded into `GEMINI.md` | compile-only, no per-file deploy |
| opencode | folded into `AGENTS.md` | compile-only, no per-file deploy |

Source: `src/apm_cli/integration/instruction_integrator.py`,
`src/apm_cli/integration/targets.py`.

## Agents

A specialist persona invoked by name, with optional model and tool
constraints. File names end in `.agent.md` and live under `.apm/agents/`.

For own-project and Git-backed package installs, symlinked agent source
files/directories (including `.apm/agents -> ../agents`) are skipped —
`apm install` warns with the skipped path. Use real files/directories
under `.apm/agents/`, or real `*.agent.md` files at the package root, then
rerun `apm install`. Local-path dependencies (`./...` or `../...`) still
work: contained symlinks are validated and copied as real files into
`apm_modules/` before agent discovery.

### Frontmatter

```yaml
---
name: security-review
description: Reviews diffs for OWASP top-10 issues and missing input validation.
model: gpt-5
tools:
  Read: true
  Grep: true
---
```

| Key | Required | Purpose |
|---|---|---|
| `name` | recommended | Display name; defaults to filename stem |
| `description` | yes | Used by Cascade and Copilot to decide when to surface the agent |
| `model` | optional | Pinned model the harness should switch to when invoked |
| `tools` | optional | Whitelist of tools the persona may call |
| `color` | optional | Display color for harnesses that render it (Copilot, Claude, OpenCode) |
| `handoffs` | optional | List of agent names (or VS Code structured handoff objects) this agent can hand off to |

Per-target field handling:

- `model` and `tools` reach Copilot, Claude, Grok Build, Cursor, and
  OpenCode verbatim.
- Kiro receives only `description`, `model`, and `tools`; unknown fields
  (including `name`) are stripped because Kiro derives agent identity from
  the deployed path. Tools are permission-bearing for Kiro: each value must
  be one of `read`, `write`, `shell`, `web`, `subagent`, `knowledge`,
  `context`, `todo_list`, `@mcp`, `@builtin`, `*`. Any unsupported tag means
  the agent is not deployed at all (fails closed).
- Codex translates only `name`, `description`, and the Markdown body; APM
  does not yet generate per-agent MCP transport definitions to preserve
  `model` or `tools`. When `tools` is present, `apm install` warns that the
  generated agent may inherit every project/session MCP server.
- Windsurf and Gemini do not receive `.agent.md` files at all — author
  personas as skills for Windsurf; Gemini CLI has no agents primitive.
- OpenCode is the strictest verbatim target: `tools` must be a
  `tool-name: boolean` mapping (not a list or string), and `color` must be
  a `#rrggbb` hex literal or one of its theme names (`primary`,
  `secondary`, `accent`, `success`, `warning`, `error`, `info`).
  `apm install -t opencode` warns at install time when a shape would be
  rejected at load time; the file still deploys.

### Agent compilation targets

| Target | Output path | Transform |
|---|---|---|
| copilot | `.github/agents/<name>.agent.md` | verbatim |
| claude | `.claude/agents/<name>.md` | verbatim |
| grok-build | `.grok/agents/<name>.md` | verbatim |
| cursor | `.cursor/agents/<name>.md` | verbatim |
| opencode | `.opencode/agents/<name>.md` | verbatim |
| codex | `.codex/agents/<name>.toml` | `name`/`description` → TOML; body becomes `developer_instructions`; unsupported `tools` warns |
| kiro | `.kiro/agents/<relative-stem>.md` | `description`, `model`, `tools` kept; `name` and unknown fields stripped; identity from path; fails closed on unsupported tools |
| windsurf | not deployed | Windsurf has no agents primitive — author personas as skills (Cascade auto-invokes by description) |
| gemini | not deployed | Gemini CLI has no agents primitive |

> **Migration note**: earlier APM versions compiled `.apm/agents/*.agent.md`
> to `.windsurf/skills/<name>/SKILL.md` with `model`/`tools` stripped. That
> mapping is removed — agents no longer deploy to Windsurf at all. Re-author
> as a skill under `.apm/skills/<name>/SKILL.md` if the persona still needs
> to reach Windsurf.

Source: `src/apm_cli/integration/agent_integrator.py`,
`src/apm_cli/integration/targets.py`.

## Verify before shipping

```bash
apm compile --validate                  # frontmatter + structure check, no writes
apm install --dry-run --target cursor   # preview agent deployment
apm preview <script>                    # if the agent is wired to a script
```

See also: [Choosing between an instruction and an agent](choosing-instructions-vs-agents.md).
