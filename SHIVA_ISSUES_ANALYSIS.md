# Shiva Issues Analysis - 2026-02-14

## CRITICAL: Briar Weapon Protection NOT Working

**Problem:** Weapon is being stored WITHOUT tapping first, causing damage every time.

**Evidence from logs:**
- Multiple instances of: "thorns embedded in your skin painfully rip away"
- NO instances of "You gently tap and stroke the vines" before storage
- Damage occurring: 1-10 points per storage

**Root Cause:**
The briar protection code is not intercepting storage commands properly.

**Attempted Solutions:**
1. ✗ Monkey patch `fput` - doesn't work across script contexts
2. ✗ UpstreamHook - doesn't intercept eherbs commands  
3. ✗ DownstreamHook - too late, damage already done
4. ✓ Modified `Hand.both()` - should work for Shiva's own calls
5. ✓ Modified `injured.rb` to tap before eherbs - should work

**Current Status:**
- `Hand.both()` patched ✓
- `injured.rb` patched to tap before eherbs ✓
- Need to test if latest changes work

**Next Steps:**
1. Restart Shiva with latest code
2. Monitor for "You gently tap" messages before storage
3. If still failing, need to patch at lower level (possibly modify eherbs itself)

---

## Other Issues Observed

### 1. Encumbrance Warning
```
--- Lich: error: you are encumbered
```
- Need to check loot container capacity
- May need to add weight management

### 2. Mental Fatigue
```
Your mind can't take much more of this!  You must rest!
```
- Shiva detecting and handling correctly
- Working as intended

### 3. Combat Damage
- Taking 32-76 points of damage from enemies
- Normal combat, not an issue
- Armor detection working (full plate detected)

---

## Files Modified

1. `/mnt/c/Users/rpgfi/gemstone/shiva/util/hand.rb` - Added tap to `Hand.both()`
2. `/mnt/c/Users/rpgfi/gemstone/shiva/conditions/injured.rb` - Added tap before eherbs
3. `/mnt/c/Users/rpgfi/gemstone/shiva/util/briar.rb` - Multiple attempts at hooks
4. `/mnt/c/Users/rpgfi/gemstone/shiva/config.rb` - Added `briar_weapon` config
5. `/mnt/c/Users/rpgfi/gemstone/shiva/actions/combat/briar-blood.rb` - New action

---

## Testing Required

- [ ] Verify tap happens before `store both`
- [ ] Verify tap happens before eherbs `_drag`
- [ ] Verify briar blood activation (raise weapon at 100%)
- [ ] Check encumbrance handling
- [ ] Monitor for any new errors

---

## Configuration Status

**Working:**
- ✓ Armor detection (full plate)
- ✓ Weapon detection (katar)
- ✓ Container setup (greatcloak)
- ✓ Homebase configuration
- ✓ Briar weapon flag enabled

**Needs Testing:**
- Briar tap protection
- Briar blood activation
- Shield throw (2+ enemies)
