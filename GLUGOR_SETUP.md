# Glugor Testing Setup Guide (Windows)

**Character:** Glugor  
**Profession:** Warrior  
**Level:** 100  
**Setup Date:** February 14, 2026

---

## Installation Location

**Windows Path:** `C:\Users\rpgfi\gemstone\shiva\`  
**WSL Path:** `/mnt/c/Users/rpgfi/gemstone/shiva/`

---

## Configuration File

**Location:** `C:\Users\rpgfi\gemstone\shiva\config\glugor.toml`

### Required Customization

Before running, update these settings:

1. **Town Preference:**
   ```toml
   town = "icemule"  # Change to: landing, solhaven, teras, etc.
   ```

2. **Container Names (EXACT in-game names):**
   ```toml
   lootsack = "backpack"      # Your loot container
   herbsack = "cloak"         # Your herb container
   harness = "weapon harness" # Your weapon container
   gemsack = "gem pouch"      # Your gem container
   skinsack = "skin sack"     # Your skin container
   ```

3. **Weapon Names (EXACT in-game names):**
   ```toml
   main = "longsword"         # Your primary weapon
   ranged = "composite bow"   # Your bow (if you use ranged)
   skinning = "skinning knife" # Your skinning tool
   ```

4. **Gem Stockpiling (Optional):**
   ```toml
   bots = ["Makerol"]  # Add storage bot names
   ```

---

## How Shiva Finds Your Config

Shiva looks for configs in this order:
1. `C:\Users\rpgfi\gemstone\shiva\config\<charactername>.toml`
2. Falls back to default settings if not found

**For Glugor:** It will automatically load `glugor.toml` when you run Shiva as Glugor.

---

## In-Game Setup (Lich)

### 1. Verify Shiva Location

In Lich, Shiva should be at:
```
C:\Users\rpgfi\gemstone\shiva\shiva.rb
```

Or wherever your Lich scripts directory points to.

### 2. Set Lich Variables (Backup Method)

If TOML config doesn't load, set these:
```
;vars set lootsack="your_container"
;vars set herbsack="your_herb_container"
;vars set harness="your_weapon_container"
;vars set gemsack="your_gem_container"
;vars set skinsack="your_skin_container"
```

### 3. Test Commands

**Check Configuration:**
```
;shiva --config
```

**See Available Environments:**
```
;shiva --environs
```

**Detect Current Town:**
```
;shiva --detect
```

**Single Test Hunt:**
```
;shiva --env=moonsedge_castle
```

**Full Automation:**
```
;shiva --auto --daemon
```

---

## Warrior-Specific Features

### Combat Styles Supported
- ✅ Edged Weapons (swords, axes)
- ✅ Polearms (spears, halberds)
- ✅ Two-Weapon Combat
- ✅ Shield Combat
- ✅ Unarmed Combat (brawling)
- ✅ Ranged Weapons (bows)

### Warrior Actions Available
1. **Warcry: Carn's Cry** - Warrior warcry
2. **Berserk** - Rage combat
3. **Charge** - Polearm charge
4. **Shield Throw** - Ranged shield
5. **Tackle/Sweep** - Physical maneuvers
6. **Ambush** - Warrior-specific ambush logic

---

## Log Files for Analysis

### Windows Log Location
```
C:\Users\rpgfi\Documents\Simutronics\GemStone IV\Glugor\Logs\
```

### WSL Access Path
```
/mnt/c/Users/rpgfi/Documents/Simutronics/GemStone IV/Glugor/Logs/
```

### Enable Logging (In-Game)
```
LOG ON
LOG VERBOSE
```

---

## Testing Workflow

### Phase 1: Configuration Test
1. Edit `C:\Users\rpgfi\gemstone\shiva\config\glugor.toml`
2. Update container/weapon names
3. Run: `;shiva --config` (verify settings load)

### Phase 2: Single Hunt Test
1. Go to appropriate town (Icemule, Landing, etc.)
2. Run: `;shiva --environs` (see available zones)
3. Run: `;shiva --env=<zone_name>` (test single hunt)
4. Watch for errors

### Phase 3: Automation Test
1. Run: `;shiva --auto --daemon`
2. Monitor for 30-60 minutes
3. Check for issues

### Phase 4: Log Analysis
1. Collect log files from `C:\Users\rpgfi\Documents\Simutronics\GemStone IV\Glugor\Logs\`
2. Share path with me
3. I'll analyze and suggest optimizations

---

## Recommended Level 100 Hunting Zones

- **Hinterwilds** (high-level content)
- **Rift** (challenging)
- **Moonsedge Castle** (level-appropriate)
- **Duskruin Arena** (if event active)

---

## Troubleshooting

**"Could not find environment"**
- Run `;shiva --environs` to see zones
- Make sure you're in correct town

**"No environments found"**
- Run `;shiva --detect` to set town
- Or edit `glugor.toml` town setting

**"You are encumbered"**
- Empty containers (Shiva requires 0% encumbrance)

**Config not loading**
- Check file is at: `C:\Users\rpgfi\gemstone\shiva\config\glugor.toml`
- Verify character name matches filename

---

## Next Steps

1. ✅ Config file created at `C:\Users\rpgfi\gemstone\shiva\config\glugor.toml`
2. ⏳ Edit config with correct container/weapon names
3. ⏳ Test with `;shiva --config`
4. ⏳ Run single hunt test
5. ⏳ Enable full automation
6. ⏳ Collect logs for analysis

---

**Ready to configure!**

Edit: `C:\Users\rpgfi\gemstone\shiva\config\glugor.toml`
