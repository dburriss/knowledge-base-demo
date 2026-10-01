---
type: explanation
resource: https://mcfunley.com/choose-boring-technology
tags: [technology-selection, architecture, operations, engineering-practice]
generated: 2026-10-01
verified: true
status: draft
stale_after: null
sources: [inbox/archive/default/2026-10-01T044829-choose-boring-technology.md]
---

# Choose Boring Technology

Summary of Dan McKinley's essay (derived from Kellan Elliott-McCrea's approach
at Etsy) on why teams should default to well-understood technology.

## Innovation tokens

Every company gets roughly three innovation tokens: a fixed, slowly growing
supply of novelty it can afford. Choosing a new language, database, or
immature infrastructure tool spends one. Unless technology is your product,
spend tokens on the business problem instead.

## Boring is not bad

Boring means well understood, not poor. Boring-and-bad technology should be
avoided; the aim is boring-and-good(-enough) (the essay cites MySQL, Postgres,
PHP, Python, Memcached). The value is that failure modes are known. All
technology has known unknowns and unknown unknowns, but the latter are far more
numerous for new technology.

## Optimize globally

"Best tool for the job" is myopic. Each added technology brings operations
(monitoring, testing, init scripts) and cognitive overhead across the whole
organization. The best tool is the "least worst" one across as many problems as
possible, because long-term running costs dwarf build-time inconvenience.

## Choosing new technology, sometimes

Adoption should be a company-visible conversation. Suggested practices:

- Ask how you would solve the problem without adding anything new; the answer is rarely "we can't".
- Write down exactly why the current stack makes the problem prohibitively hard.
- If the new tech overlaps existing tech, commit to migrating, with a timeline.

## Just ship

Unconstrained polyglot freedom creates operational toil. Mindful choices free
engineers to think about bigger questions; technology for its own sake is
"snake oil".

## References

- [Choose Boring Technology](https://mcfunley.com/choose-boring-technology)
- [Related talk](http://boringtechnology.club)
