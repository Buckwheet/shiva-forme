# Project State: Shiva Bugfixes & Enhancements

## Goal
Fix gem stockpiling logic, implement robust disarm recovery, and modernize environment scripts.

## What Changed
*   **Stockpile Logic Fix:**
    *   Moved `stockpile_gems!` call in `teardown.rb` to execute *before* moving to the Adventurer's Guild.
    *   Fixed `dirtbag.toml` configuration to include the correct "Base" room (Library) and populated the `[stockpile]` section with gem list and bot name ("Makerol").
    *   Updated `shiva.rb` to force configuration reload (`Shiva::Config.init!`) on startup to prevent stale config issues.
*   **Disarm Recovery:**
    *   Implemented `util/disarm_tracker.rb` to track disarm events (item noun and room ID) via stream hooks.
    *   Created `actions/combat/recover.rb` (Priority 100) to use the tracker, navigate back to the room if needed, and perform a robust `kneel` -> `recover item` loop.
    *   Updated `dirtbag.toml` to define `main = "coraesine katar"` for tracking.
*   **Environment Updates:**
    *   Replaced deprecated `reaction` script with `autoreact` in Moonsedge and Rift environments.

## Commands Run
*   Modified `teardown.rb`, `shiva.rb`, `dirtbag.toml`.
*   Created `recover.rb`, `disarm_tracker.rb`.
*   Modified environment files (moonsedge_castle, etc.).
*   Deleted `spin-kick.rb` (requested).

## Files Touched
*   `c:\Users\rpgfi\gemstone\shiva\stages\teardown.rb`
*   `c:\Users\rpgfi\gemstone\shiva\shiva.rb`
*   `c:\Users\rpgfi\gemstone\shiva\config\dirtbag.toml` (User & Data dirs)
*   `c:\Users\rpgfi\gemstone\shiva\actions\combat\recover.rb`
*   `c:\Users\rpgfi\gemstone\shiva\util\disarm_tracker.rb`
*   `c:\Users\rpgfi\gemstone\shiva\environments\icemule\moonsedge_castle.rb`
*   `c:\Users\rpgfi\gemstone\shiva\environments\icemule\moonsedge_village.rb`
*   `c:\Users\rpgfi\gemstone\shiva\environments\rift\plane-4.rb`
*   `c:\Users\rpgfi\gemstone\shiva\environments\rift\scatter-north.rb`
*   `c:\Users\rpgfi\gemstone\shiva\environments\rift\scatter-south.rb`

## Next 3 Actions
- [ ] Verify gem handoff to Makerol in the next full hunting cycle.
- [ ] Monitor Disarm Recovery in action (or test manually).
- [ ] Confirm `autoreact` starts/stops correctly in updated environments.
