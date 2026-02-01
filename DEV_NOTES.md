# Developer Notes & Learnings

## Debugging Session - Jan 30, 2026

### 1. The "Ghost File" Logger Recursion
**Issue:** A `stack level too deep` error persisted in `util/file_logger.rb` even after the file was deleted.
**Cause:** Lich/Ruby processes cache loaded modules. The `Log.out` method was aliased recursively.
**Solution:**
1.  Deleted `util/file_logger.rb`.
2.  ran `emergency_fix_log.lic` to forcefully undefine/reset the method in memory.
3.  **Required a Lich Restart** to fully clear the corrupted global state.

### 2. The Missing Harness Crash
**Issue:** `SmallStatue` action crashed with `undefined method 'where' for nil:NilClass`.
**Cause:** `Containers.harness` returned `nil` because the `harness` Lich variable was unset.
**Solution:**
- **Code:** Patched `actions/meta/small-statue.rb` to rescue errors and return `nil`.
- **Config:** User set `;vars set harness="..."` to properly resolve the container.

### 3. The Spellup Dependency
**Issue:** Crash due to `uninitialized constant Spellup`.
**Cause:** `actions/support/spellup.rb` assumed a global `Spellup` class (from a custom `spellup.lic`) existed.
**Solution:** Patched the file to check `defined?(::Spellup)` before execution.

### 4. Katar / UAC Combat Stall
**Issue:** Combat loop stalled (`noop`) after `Subdue` paralyzed the target.
**Cause:**
- `Subdue` disables itself on paralyzed targets.
- `Kill` action checks `Tactic.edged?` or `Tactic.polearms?`.
- `Tactic.edged?` strictly required `Skills.edgedweapons`, but Katars use `Brawling`.
- `katar` was missing from the `Edged` noun list.
**Solution:**
- Added `katar` to `Tactic::Nouns::Edged` in `util/tactic.rb`.
- (User confirmed they use Edged skill with Katars, or implied the classification was sufficient).

### 5. Infinite Loops
**Issue:** `eforage` script getting stuck.
**Solution:** Modified `eforage` to handle "hands full" errors (stow logic) and ignore "VOID" detection false positives.
