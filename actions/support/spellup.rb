module Shiva
  class Spellup < Action
    @tags = %i(setup)

    # Comprehensive list from ewaggle defaults
    SpellsToTrack = [
      101, 102, 103, 107, 115, 120,    # Minor Spirit
      202, 211, 215, 219,              # Major Spirit
      303, 307, 310, 313, 314, 319, 320, # Cleric
      401, 406, 414, 425, 430,         # Minor Elemental
      503, 507, 508, 509, 513, 520, 535, # Major Elemental
      601, 602, 604, 605, 606, 612, 613, 617, 618, 620, 625, 640, # Ranger
      704, 712, 716,                   # Sorcerer
      905, 911, 913, 920,              # Wizard
      1003, 1006, 1007, 1010, 1019,    # Bard
      1109, 1119, 1125, 1130,          # Empath
      1202, 1204, 1208, 1214, 1215, 1220, # Minor Mental
      1601, 1603, 1606, 1610, 1611, 1612, 1616 # Paladin
    ]

    # Thresholds
    EMERGENCY_THRESHOLD = 2 # Minutes
    TOPOFF_THRESHOLD    = 20 # Minutes

    def priority
      1
    end

    def self.top_off
      action = self.new(nil)
      action.restore_spells(TOPOFF_THRESHOLD)
    end

    def available?
      # Emergency check: returns true if any spell is dangerously low
      check_spells(EMERGENCY_THRESHOLD, dry_run: true)
    end

    def check_spells(threshold, dry_run: false)
      SpellsToTrack.any? do |spell_num|
        spell = Spell[spell_num]
        
        # Basic checks
        next false unless spell.known?
        next false unless spell.affordable?
        next false if spell.active? && spell.timeleft >= threshold
        
        # Class restrictions
        if spell_num == 102
          next false unless %w(Empath Cleric Sorcerer Wizard).include?(Char.prof)
        end

        return true if dry_run # Found one needed spell

        # Cast logic
        Log.out("Casting #{spell.name} (#{spell.num}) - Duration: #{spell.timeleft.round(1)}m", label: :shiva)
        result = spell.cast
        
        # Simple backoff if cast fails or we run OOM mid-loop
        unless result
           Log.out("Failed to cast #{spell.num}", label: :shiva)
        end
        
        # Return true to indicate we did something (or tried to)
        true
      end
    end

    def restore_spells(threshold)
      # Keep casting until all spells meet the threshold or we can't cast anymore
      loop do
        did_cast = check_spells(threshold)
        break unless did_cast
        
        # Safety break if mana/spirit/etc happens to drop or state changes
        break if checkmana < 10
      end
    end

    def grouped
      restore_spells(TOPOFF_THRESHOLD)
    end

    def moonsedge
      Stance.guarded
      room = Room.current.id
      32469.go2
      restore_spells(TOPOFF_THRESHOLD)
      room.go2
    end

    def other
      Stance.guarded
      Walk.apply do
        restore_spells(TOPOFF_THRESHOLD)
      end
    end

    def apply(foe)
      Log.out("Spellup required. Restoring spells.", label: :shiva)
      return self.grouped if not Group.empty?
      
      if %i(moonsedge_castle moonsedge_village).include?(self.env.name)
        self.moonsedge
      elsif %i(escort)
        restore_spells(TOPOFF_THRESHOLD)
      else
        self.other
      end
    end
  end
end