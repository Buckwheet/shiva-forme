module Shiva
  class Censure < Action
    def priority
      85
    end

    # Explicitly redefine initialize to wipe the old "ghost" version from memory
    def initialize(mod)
      super(mod)
    end

    def available?(foe)
      # AOE Condition: swarmed by at least 2 mobs
      # Use env.foes (correct API) instead of env.mobs
      return false unless self.env.foes.count >= 2
      
      # Mana check (m10)
      return false unless Char.mana >= 10
      
      # Specialize: Censure (316)
      return false unless Spell[316].known? and Spell[316].affordable?

      # State-based "Room" logic:
      return self.env.foes.any? { |m| 
        not (m.status.include?('stunned') or 
             m.status.include?('prone') or 
             m.status.include?('lying') or 
             m.status.include?('sleeping'))
      }
    end

    def apply(foe)
      fput "incant 316"
      waitcastrt?
    end
  end
end
