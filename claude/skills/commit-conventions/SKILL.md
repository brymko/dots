---
name: commit-conventions
description: Personal Conventional Commits style — past-tense descriptions, lowercase, ≤72 chars, atomic commits. Use when creating any git commit, drafting commit messages, or writing PR titles. NOTE the past-tense rule differs from the upstream Conventional Commits imperative form.
---

## Conventional Commits Format
All commits MUST follow the Conventional Commits specification.

**Format**:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Type Requirements
**Required types**:
- `feat`: New feature or capability
- `fix`: Bug fix or correction
- `refactor`: Code restructuring without behavior change
- `perf`: Performance improvement
- `test`: Test addition or modification
- `docs`: Documentation-only change
- `build`: Build system or dependency change
- `ci`: CI/CD configuration change
- `chore`: Maintenance task

**Examples**:
```
feat(consensus): implemented committee selection
fix(crypto): corrected signature verification
refactor(network): extracted connection pooling
perf(storage): added LRU cache for state reads
test(consensus): added byzantine fault test
```

## Description Requirements
Description MUST:
- Use past tense: "added" not "add" or "adds"
- Be lowercase
- Omit trailing period
- Not exceed 72 characters
```
COMPLIANT: "implemented threshold signature aggregation"
VIOLATION: "Implemented threshold signature aggregation."
VIOLATION: "implement threshold signature aggregation"
```

## Body Requirements
Body SHOULD be provided for non-trivial changes. Body MUST:
- Be separated from description by blank line
- Explain what and why, not how
- Wrap at 72 characters

## Footer Requirements
Footers MAY include:
- Issue references: `Fixes #123`, `Refs #456`

## Atomicity Requirements
Each commit MUST:
- Represent single logical change
- Compile successfully
- Pass all tests

Commits MUST NOT:
- Mix unrelated changes
- Leave codebase in broken state
- Combine refactoring with behavior changes
