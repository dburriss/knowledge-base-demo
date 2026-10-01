---
type: how-to
resource: https://devonburriss.me/maintainable-unit-tests/
tags: [unit-testing, testing, refactoring, test-doubles, builders, csharp]
generated: 2026-10-01
verified: true
status: draft
stale_after: null
sources: [inbox/archive/default/2026-10-01T052940-maintainable-unit-tests.md]
---

# Keep unit tests maintainable

Tips from Devon Burriss for avoiding test suites that break in cascades when
application code is refactored. Examples in the source are C# (xUnit, NSubstitute).

## 1. Test behavior, not structure

- Enter at a natural boundary (e.g. a use-case class) and assert on outcomes, not on calls to its dependencies.
- A test like "validator `IsValid` was called once" encodes implementation; moving validation into the `Person` entity forces rewriting it.
- Instead assert the behavior: after `CreatePerson.With("Bob")`, the repository contains a person named "Bob".
- That test survives refactors such as removing the validator, adding `Person.IsValid()`, and finally making invalid `Person` unrepresentable via constructor checks.
- A "unit" is whatever you need it to be. Small detail tests are fine if you are happy to delete them; test code is code that needs maintenance.

## 2. Use in-memory dependencies

Prefer a simple in-memory implementation (e.g. `InMemoryPersonRepository` over a dictionary) to mocking frameworks, because they are:

1. Easier to update than mocks created in every test or fixture.
2. Easier to set up and read when combined with builders.
3. Simple to understand and good for debugging.

The cost is some upfront effort to write them.

## 3. Build up test tooling

- **In-memory dependencies**, as above.
- **Builders** for test data, avoiding many near-identical setup methods. Add an `implicit` conversion to the built type; a library such as [Fluency](https://github.com/nrjohnstone/Fluency) can help.
- **Accessors**: static classes such as `A` (entities, value objects) and `Given` (external-service builders) for concise setup, e.g. `Given.People.With(A.Person, A.Person, A.Person)` or `people.Create(A.Person.With(name: "Bob"))`.
- Mocking frameworks still have a place for things unlikely to change and that you don't care about, ideally used inside builders rather than directly in tests.

## Reference

- [Source post](https://devonburriss.me/maintainable-unit-tests/) (its code is illustrative; do not copy into production)
