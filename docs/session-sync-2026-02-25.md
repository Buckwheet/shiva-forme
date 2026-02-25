# Shiva Sync — 2026-02-25

## What Happened
Production (gemstone/shiva) and dev (Development/shiva-forme) were out of sync across two machines. Production was ahead — it had all the warrior brawling work from sessions Feb 18-21. Dev was synced to GitHub from production → dev on this machine.

## What Was Synced
All production `.rb`, `.lic`, `.toml`, and `.md` files were copied into dev, committed, and pushed to GitHub (`Buckwheet/shiva-forme`).

### New Files (not previously in dev)
- `actions/combat/brawl.rb` — brawling combo chain (jab/punch/kick/grapple by tier)
- `actions/combat/clash.rb` — shield clash action
- `actions/combat/fury.rb` — brawling assault (Fury)
- `actions/combat/mighty-blow.rb` — mighty blow action
- `actions/combat/shield-bash.rb` — shield bash action
- `actions/combat/shield-trample.rb` — shield trample action
- `actions/combat/briar-blood.rb` — briar flare blood action
- `actions/combat/bearhug.rb` + `.disabled` — bearhug (disabled)
- `util/briar.rb` — briar utility
- `config/glugor.toml` — Glugor character config
- `shiva-setup.lic` — Lich setup script
- `.gitignore` — excludes logs, backups, temp files

### Modified Files (25 total)
- Combat: feint, flurry, kill, seanettes-shout, shield-throw, smite, warcry-carns-cry
- Meta: belly-of-the-beast, feat-absorb-magic, feat-dispel-magic, loot-area, rest, symbol-of-bless, symbol-of-courage, symbol-of-restoration, wander
- Conditions: burrowed, injured
- Core: config.rb, shiva.rb, stages/main.rb, stages/teardown.rb
- Util: armor.rb, hand.rb, tactic.rb

## Current Warrior Config (Glugor)
```toml
[combat]
brawling_weapon = "zorchar knuckle-blade"
brawl_tier3 = "punch"
```

### Priority Chain
```
-100  Berserk (stun break)
 1    Seanette's Shout
 2    Carn's Cry (2+ foes)
 6    Smite (noncorporeal foes)
 4    Growl (30s cooldown)
 5    Shield Bash / Clash
41    Fury (brawling assault)
101   Brawl (combo chain filler)
```

## Pending Work (pick up from here)
1. **Verify footwrap bless** — Fix 35 (symbol-of-bless.rb) needs in-game restart to confirm
2. **Fix lootsack var** — Run `;vars set lootsack=weathered cloud grey greatcloak` in-game if not done
3. **Grapple Spec vs Punch Spec** — Research/test what Grapple Spec's Fury bonus does before choosing specialization
4. **Briar growth** — Monitor influence % over hunts, should eventually start flaring
5. **Thrown Weapons Bandolier** — Design doc at `docs/thrown-bandolier-design.md`, not yet implemented
6. **Zorchar stats** — 197 procs, avg 23.9 HP/proc, biggest damage source. Keep tracking.

## On the Other Machine
After pulling:
1. `git pull origin main`
2. Copy changed files from `Development/shiva-forme/` → `gemstone/shiva/` for production testing
3. Pick up from the pending work list above
