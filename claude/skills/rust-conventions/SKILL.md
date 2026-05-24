---
name: rust-conventions
description: Personal Rust style + idioms (Edition 2024, nightly, parking_lot over std, zero-alloc preferences, error-handling shape, doc access via crate source). Use when editing Rust code (`*.rs`, `Cargo.toml`), reviewing Rust changes, or answering Rust style/idiom questions.
---

## Code Style Requirements
```
Line length: 3 spaces, 100 columns
Edition: 2024
Toolchain: nightly
```

## Modern Pattern Requirements (2024 Edition)
**Match ergonomics**:
```rust
REQUIRED: match &value { Some(x) => ... }
```

**Random generation (rand 0.9+)**:
```rust
REQUIRED: rand::random::<T>()
REQUIRED: rand::rng().gen_range(0..10)
```

**Error handling**:
```rust
#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("operation failed: {reason}")]
    OpFailed {
        reason: String,
        #[source]
        source: Option<Box<dyn std::error::Error>>,
    },

    #[error("io error")]
    Io(#[from] std::io::Error),
}
```

## Zero-Allocation Requirements
**Allocation hierarchy** (preference order):
1. Stack (arrays, fixed-size types)
2. Borrowing (references, slices)
3. Buffer reuse (`.clear()`, not reallocation)

## Comment and Documentation Requirements
**Code comments**:
- Meta-commentary is PROHIBITED
- `// SAFETY:` is REQUIRED for `unsafe` blocks—invariant justification is REQUIRED
- Doc comments MUST use `[`Type`]`, `[`Module::Item`]` link syntax

## Concurrency Requirements
**Lock types**:
```rust
PROHIBITED: std::sync::{Mutex, RwLock}
REQUIRED: parking_lot::{Mutex, RwLock}
```

## Documentation Access Requirements
**`cargo doc` is PROHIBITED**. Source MUST be directly accessed: `~/.cargo/registry/src/index.crates.io-*/[crate]-[version]/`
