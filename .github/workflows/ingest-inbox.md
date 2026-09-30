---
description: Curate raw captures in inbox/raw/ into OKF-fronted, Diataxis-organized knowledge notes and open a PR.
on:
  push:
    branches: [main]
    paths:
      - "inbox/raw/**"
  workflow_dispatch:
permissions:
  contents: read
engine: copilot
strict: false
features:
  dangerously-disable-sandbox-agent: true
concurrency:
  group: ingest-inbox
  cancel-in-progress: false
sandbox:
  agent: false
tools:
  web-fetch:
  web-search:
safe-outputs:
  threat-detection: false
  create-pull-request:
    title-prefix: "[ingest] "
    labels: [knowledge, automated]
    draft: false
    allowed-files:
      - "*.md"
      - "**/*.md"
---

# Ingest inbox

You are curating this knowledge base. Follow the instructions in
`.github/agents/ingestor.agent.md` (the `ingestor` agent) exactly: process every
item under `inbox/raw/` (excluding `.gitkeep`), oldest first, curating each into a
structured note in the right domain folder with OKF frontmatter and the correct
Diataxis type, then archive the raw item to `inbox/archive/`.

Skills for reference live in `.agents/skills/` (`organizing-documentation`,
`semantic-search`, `eru`).

Do not commit yourself: the pull-request safe output collects your changes.
If `inbox/raw/` has no items, do nothing.
