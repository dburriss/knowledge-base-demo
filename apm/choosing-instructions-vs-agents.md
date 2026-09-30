---
type: explanation
resource: https://microsoft.github.io/apm/producer/author-primitives/instructions-and-agents/#agents
tags: [apm, instructions, agents, diataxis]
generated: 2026-09-30
verified: false
status: draft
stale_after: null
sources: [inbox/archive/default/2026-09-30T050933-instructions-and-agents.md]
---

# Choosing between an instruction and an agent

APM's two primitives pair naturally but serve different jobs. An
**instruction** is a scope-attached rule: a coding standard, naming
convention, or review checklist that fires automatically when the agent
touches files matching a glob. An **agent** is a persona scoping module: a
named specialist (security reviewer, migration assistant, on-call SRE) the
user invokes explicitly. Instructions shape *how* the model behaves on any
given file; agents shape *who* the model becomes when summoned.

## When to pick each

Pick **instructions** when:

- The rule applies to a *file pattern*, not a workflow.
- You want the agent to follow it implicitly, without being summoned.
- The content is short, declarative, and reviewable as policy.

Pick **agents** when:

- A user needs to *invoke* a specialist on demand.
- The behavior involves a sequence of steps, decisions, or model switches,
  not a static rule.
- You want to scope tool access (e.g. a read-only review persona).

Many packages ship both: instructions for the always-on guardrails, plus
one or two agents for the deeper workflows that warrant a dedicated
persona.

## Authoring conventions

**Instructions** — lead with bullets, not prose (they're read by an agent
mid-task); keep one topic per file (split `python-style` from
`python-testing` rather than co-mingling); cite in-repo paths with
backticks; skip greetings and meta commentary and state the rule directly.

**Agents** — open with role and scope in two sentences (the harness uses
this as the system prompt); define what the persona will and will not do,
since boundaries make agents useful; list expected inputs ("the open PR
diff") and outputs ("a markdown review with file:line citations"); keep the
body under 300 lines, since long agents crowd out the harness's context
window before the user's task even loads.

## Common pitfalls

- **Missing `applyTo`.** An instruction without it stops being
  scope-attached and gets folded into the compiled context file instead of
  binding to `**/*.ts` (or whatever pattern was intended).
- **Agent named `default` or `start`.** These collide with script
  resolution in `apm run`. Pick a descriptive name.
- **Targeting an agent at Windsurf or Gemini.** Neither harness has an
  agents primitive. Cascade auto-invokes skills by description, and Gemini
  folds context into `GEMINI.md`. If a persona must reach those targets,
  author it as a skill under `.apm/skills/<name>/SKILL.md`.
- **`tools:` as a list, or a named color, on an OpenCode-targeted agent.**
  OpenCode's loader rejects `tools: [Read, Grep]` and colors like `cyan`.
  Use the mapping form (`tools: {Read: true}`) and a `#rrggbb` hex literal
  or one of OpenCode's theme names.
- **Agent body that re-states global instructions.** Agents inherit the
  workspace's compiled context. Restate only what the persona needs to
  *override* or *add* — don't duplicate a `python-style` instruction inside
  `code-reviewer.agent.md`.
- **Co-mingling rules and persona.** A 600-line `.agent.md` that contains
  style rules, a review checklist, and a persona prompt is two primitives
  in a trench coat. Split it.

See also: [Instructions and agents: frontmatter and compilation
targets](instructions-and-agents-reference.md) for the full frontmatter
schema and per-target compilation behavior.
