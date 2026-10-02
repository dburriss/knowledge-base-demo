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

The curated notes are published to GitHub Pages by `.github/workflows/pages.yml`, which runs
`eru sync` and `eru site generate` (the repo is registered as an OKF bundle source in `.eru/config.json`).
Enable it once under Settings → Pages → Source: GitHub Actions.

Locally, `eru inbox process -i kb` does the same via the `default` channel (`copilot --acp`).

## Setup

Find the detailed setup instructions here: [Generate docs from inbox changes with a GitHub Agentic Workflow](https://github.com/dburriss/eru/blob/main/docs/how-to/generate-docs-from-inbox-with-gh-aw.md)

```bash
mise install          # apm, dotnet, ck
dotnet tool install --global Eru.Tool
apm install           # skills + ingestor agent + eru MCP
gh aw compile         # after editing .github/workflows/*.md
```

The workflow uses gh-aw's `copilot` engine; add the `COPILOT_GITHUB_TOKEN` repo secret (`gh aw secrets`).

The inbox `kb` is registered in `.eru/config.json` (repo-local), or a global to allow sending notes from anywhere. If you have a single inbox, you can drop the inbox flag `-i kb`.
