# knowledge-base-demo

A demo knowledge base built with [eru](https://github.com/dburriss/eru), following
[Set up a knowledge repo](https://github.com/dburriss/eru/blob/main/docs/how-to/set-up-a-knowledge-repo.md),
with curation run by a [GitHub Agentic Workflow](https://github.com/github/gh-aw).

## How it works

1. Register this repo as a remote inbox, then send it a note, file, or URL:
   ```bash
   eru inbox add kb git@github.com:dburriss/knowledge-base-demo.git
   eru inbox send "note" -i kb
   ```
2. Wait a few minutes. The ingestor agent curates your item into an OKF note and merges it
   automatically; there's nothing to push or review.
3. View your curated notes: start at [`index.md`](index.md), or browse the topic folders
   (e.g. [`software-engineering/`](software-engineering/)). Your original item is kept in
   `inbox/archive/`.

Locally, `eru inbox process -i kb` does the same via the `default` channel (`copilot --acp`).

## Setup

```bash
mise install          # apm, dotnet, ck
dotnet tool install --global Eru.Tool
apm install           # skills + ingestor agent + eru MCP
gh aw compile         # after editing .github/workflows/*.md
```

The workflow uses gh-aw's `copilot` engine; add the `COPILOT_GITHUB_TOKEN` repo secret (`gh aw secrets`).

The inbox `kb` is registered in `.eru/config.json` (repo-local), or a global to allow sending notes from anywhere. If you have a single inbox, you can drop the inbox flag `-i kb`.
