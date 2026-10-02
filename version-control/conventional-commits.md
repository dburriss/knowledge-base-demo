---
type: reference
resource: https://www.conventionalcommits.org/en/v1.0.0/
tags: [conventional-commits, git, commit-messages, semver, specification]
generated: 2026-10-01
status: draft
stale_after: null
sources: [inbox/archive/default/2026-09-30T061516-v1-0.md]
---

# Conventional Commits 1.0.0

A lightweight convention on top of commit messages that gives commit history
explicit structure, making it easier to build automated tooling. It dovetails
with [SemVer](https://semver.org).

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types and SemVer mapping

| Element | Meaning | SemVer |
|---|---|---|
| `fix:` | Patches a bug | PATCH |
| `feat:` | Introduces a feature | MINOR |
| `BREAKING CHANGE:` footer, or `!` after type/scope | Breaking API change (any type) | MAJOR |

Other types are allowed and have no implicit SemVer effect. The Angular-based
`@commitlint/config-conventional` recommends `build`, `chore`, `ci`, `docs`,
`style`, `refactor`, `perf`, `test`.

## Rules (summary of the specification)

- Prefix is a type noun, optional `(scope)`, optional `!`, then `: `.
- Description follows immediately; body starts one blank line later and is free-form.
- Footers start one blank line after the body: `token: value` or `token #value`,
  with `-` replacing spaces in tokens (e.g. `Acked-by`). `BREAKING CHANGE` is the exception.
- Breaking changes: `BREAKING CHANGE: <description>` footer (`BREAKING-CHANGE` is a synonym)
  and/or `!` right before the colon; with `!` the footer may be omitted.
- Units are case-insensitive except `BREAKING CHANGE`, which MUST be uppercase.

## Examples

```
feat(parser): add ability to parse arrays
feat(api)!: send an email to the customer when a product is shipped
feat!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```

## Benefits

Automatic CHANGELOG generation, automatic version bumps, clearer communication
of change nature, triggering build/publish processes, and a more explorable history.

## FAQ highlights

- Wrong type before merge/release: fix with `git rebase -i`. A non-conforming commit is only missed by spec-based tools.
- Not all contributors need to comply: with squash merges, maintainers can fix the message at merge.
- Reverts are not defined by the spec; one suggestion is a `revert` type with a footer listing the reverted SHAs.
- Extensions to the spec should be versioned with SemVer.

## References

- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
