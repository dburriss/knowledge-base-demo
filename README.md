# knowledge-base-demo

A demo knowledge base built with [eru](https://github.com/dburriss/eru). Send in a note, file or
URL and it is curated into a structured note, published as a website, and made searchable by AI
agents. For how any of it works, see the [eru docs](https://github.com/dburriss/eru/tree/main/docs).

## 1. Set up the knowledge base

Follow [Set up a knowledge repo](https://github.com/dburriss/eru/blob/main/docs/how-to/set-up-a-knowledge-repo.md),
then add curation with a GitHub Agentic Workflow: [Generate docs from inbox changes with a GitHub Agentic Workflow](https://github.com/dburriss/eru/blob/main/docs/how-to/generate-docs-from-inbox-with-gh-aw.md).

```bash
mise install          # apm, dotnet, ck
dotnet tool install --global Eru.Tool
apm install           # skills + ingestor agent + eru MCP
gh aw compile         # after editing .github/workflows/*.md
```

Add the `COPILOT_GITHUB_TOKEN` repo secret (`gh aw secrets`).

### Publish a website with GitHub Pages

The curated notes are published at **<https://devonburriss.me/knowledge-base-demo>** by
[`.github/workflows/pages.yml`](.github/workflows/pages.yml), which runs `eru site generate`.

1. Enable Pages under Settings → Pages → Build and deployment → Source: **GitHub Actions**.
2. Push to `main`, or run the workflow manually. It also reruns after each ingest.

Check the notes are valid with `eru okf validate .` (and `eru okf fix .` to repair them).

## 2. Connect it to agents

Register the source once:

```bash
dotnet tool install --global Eru.Tool
eru source add https://github.com/dburriss/knowledge-base-demo --name kb --scan --global
eru sync
```

Then give your agent either option.

**MCP.** Add the eru server to your client config (see [`.mcp.json`](.mcp.json) for an example):

```json
{
  "mcpServers": {
    "eru": { "command": "eru", "args": ["mcp"] }
  }
}
```

The agent gets `search_knowledge`, `read_artifact` and `refresh_knowledge`.

**CLI and skill.** Add the eru skill to the consuming project's `apm.yml` and run `apm install`:

```yaml
dependencies:
  apm:
    - dburriss/eru/skills/eru
```

The agent can then run commands like `eru search diataxis` or `eru add kb:documentation/diataxis.md`.

Use MCP for lookups. Use the CLI to pull notes into a project as tracked files.

## Extra: use it yourself

**Add knowledge.** Register this repo as a remote inbox, then send it notes, links or files:

```bash
eru inbox add kb git@github.com:dburriss/knowledge-base-demo.git
eru inbox send "note" -i kb
eru inbox send https://example.com/article -i kb
eru inbox send ./notes.pdf -i kb
```

After a few minutes it is curated and merged automatically. Nothing to push or review. Your original
is kept in `inbox/archive/`. With a single inbox you can drop `-i kb`.

**Browse it.** Use the [website](https://devonburriss.me/knowledge-base-demo), or start at
[`index.md`](index.md).

**Search it.** Register the source as in [section 2](#2-connect-it-to-agents), then use the CLI:

```bash
eru search diataxis              # find notes by term
eru search diataxis -t docs      # filter by tag
eru source files kb              # list everything the source publishes
eru add kb:documentation/diataxis.md   # copy a note into your project
eru sync                         # refresh sources and the search index
```
