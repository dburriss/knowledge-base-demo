# knowledge-base-demo

A demo knowledge base built with [eru](https://github.com/dburriss/eru), following
[Set up a knowledge repo](https://github.com/dburriss/eru/blob/main/docs/how-to/set-up-a-knowledge-repo.md),
with curation run by a [GitHub Agentic Workflow](https://github.com/github/gh-aw).

## How it works

1. Capture material into `inbox/raw/` (`eru inbox send "note" -i kb`, or drop files in).
2. Push to `main`. `.github/workflows/ingest-inbox.md` runs the `ingestor` agent, which
   curates each raw item into an OKF-fronted, Diataxis-classified note and opens a PR.
3. Review and merge. Processed raw items move to `inbox/archive/`.

Locally, `eru inbox process -i kb` does the same via the `default` channel (`copilot --acp`).

## Setup

```bash
mise install          # apm, dotnet, ck
dotnet tool install --global Eru.Tool
apm install           # skills + ingestor agent + eru MCP
gh aw compile         # after editing .github/workflows/*.md
```

The workflow uses gh-aw's `copilot` engine; add the `COPILOT_GITHUB_TOKEN` repo secret (`gh aw secrets`).

The inbox `kb` is registered in `.eru/config.json` (repo-local), not the global eru config.
