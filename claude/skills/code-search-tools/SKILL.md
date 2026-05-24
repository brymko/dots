---
name: code-search-tools
description: Tool-selection matrix for code search/refactor — rg for text, sd for global replace, sg (ast-grep) for AST-level structural patterns, fd for file location, fd+sd for cross-file mass rename. Use when planning a multi-file search, refactor, or rename, or when picking between grep/sed/find equivalents.
---

## sd: Find & Replace
**Application**: Mass refactoring, renaming, string replacement
```bash
# In-place replacement
sd 'old_name' 'new_name' file.rs --write
# Regex capture groups
sd '(\w+)_old' '$1_new' file.rs
# Multiple files
fd -e rs -x sd 'OldType' 'NewType' {} --write
```

## ast-grep (sg): Structural Code Search
**Application**: AST-level patterns, semantic search
```bash
# Function location
sg -p 'fn $NAME($$$)' --lang rust
# Structural replacement
sg -p 'old_api($$$)' -r 'new_api($$$)' --update all
```

## Tool Selection Matrix
```
Requirement                         Tool
├─ Text search in files          → rg
├─ Global text replacement       → sd
├─ Code pattern search           → sg
├─ File location                 → fd
├─ Cross-file mass rename        → fd + sd
```
