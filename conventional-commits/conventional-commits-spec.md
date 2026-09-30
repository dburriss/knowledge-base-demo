---
type: reference
resource: https://www.conventionalcommits.org/en/v1.0.0/
tags: [conventional-commits, git, commit-messages, semver, changelog]
generated: 2026-09-30
verified: false
status: draft
stale_after: null
sources: [inbox/archive/default/2026-09-30T061516-v1-0.md]
---

# Conventional Commits v1.0.0 specification

Conventional Commits is a specification for writing commit messages in a
structured, machine-readable format. It provides an easy set of rules for
creating an explicit commit history, which makes it easier to write
automated tooling on top of — generating changelogs, determining semantic
version bumps, and communicating the nature of changes to teammates and
other stakeholders.

## Commit message structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The commit message should be structured as follows:

1. A **type** that conveys the intent of the change.
2. An optional **scope**, in parentheses, providing additional contextual
   information (e.g. the affected module or component).
3. A colon and space, then a short **description** in the imperative,
   present tense (e.g. "change" not "changed" nor "changes").
4. An optional longer **body**, providing additional contextual information
   about the code changes, after a blank line following the description.
5. One or more optional **footers**, after a blank line following the body.
   Footers follow the `git trailer` convention: a token (using `-` in place
   of whitespace, or `BREAKING CHANGE`), then either `: ` or ` #`, then a
   value.

## Types

| Type | Meaning |
|---|---|
| `fix` | Patches a bug in the codebase (correlates with `PATCH` in semantic versioning) |
| `feat` | Introduces a new feature (correlates with `MINOR` in semantic versioning) |

Types other than `fix` and `feat` are allowed — for example
[Angular convention](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#-commit-message-format)
recommends `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`,
`test`, and others. These have no implicit effect on semantic versioning
(unless they include a `BREAKING CHANGE` footer).

## Breaking changes

A commit that introduces a breaking API change (correlating with `MAJOR` in
semantic versioning) MUST be indicated in one of two ways:

- A `BREAKING CHANGE:` footer, with a description of the change,
  justification, and migration notes.
- An exclamation mark (`!`) immediately before the `:` in the type/scope
  prefix, e.g. `feat!:` or `feat(api)!:`. In this shorthand form, a
  `BREAKING CHANGE:` footer may be omitted, and the description itself is
  used to describe the breaking change.

`BREAKING CHANGE` MUST be uppercase when used as a footer token.

## Examples

```
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for extending
other config files
```

```
feat(api)!: send an email to the customer when a product is shipped
```

```
docs: correct spelling of CHANGELOG
```

```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Reviewed-by: Z
Refs: #123
```

## Specification rules (summary)

- Commits MUST be prefixed with a type, followed by an optional scope, an
  optional `!`, and a required terminal colon and space.
- The `feat` type MUST be used when a commit adds a new feature; `fix` MUST
  be used when a commit represents a bug fix.
- A scope MAY be provided after a type, as a noun in parentheses, e.g.
  `fix(parser):`.
- A description MUST immediately follow the colon and space after the
  type/scope prefix.
- A longer commit body MAY be provided after the short description,
  providing additional contextual information; it begins one blank line
  after the description and may consist of any number of newline-separated
  paragraphs.
- One or more footers MAY be provided one blank line after the body; each
  footer consists of a word token, followed by either `: ` or ` #`,
  followed by a string value (this is inspired by the
  [git trailer convention](https://git-scm.com/docs/git-interpret-trailers)).
- A footer's token MUST use `-` in place of whitespace characters (this
  helps distinguish the footer section from a multi-paragraph body), except
  for `BREAKING CHANGE`, which MAY also be used as a token.
- Types other than `feat` and `fix` MAY be used, e.g. `docs:`, `style:`,
  `refactor:`, `perf:`, `test:`, `build:`, `ci:`, `chore:`.
- The units of information that make up Conventional Commits MUST NOT be
  treated as case sensitive by implementors, with the exception of
  `BREAKING CHANGE`, which MUST be uppercase.
- `BREAKING-CHANGE` MUST be synonymous with `BREAKING CHANGE` when used as a
  footer token.

## Why use Conventional Commits

- Automatically generating changelogs.
- Automatically determining a semantic version bump (based on the types of
  commits landed).
- Communicating the nature of changes to teammates, the public, and other
  stakeholders.
- Triggering build and publish processes.
- Making it easier for people to contribute to projects, by allowing them
  to explore a more structured commit history.
