module Shiva
  class DivineWrath < Action
    def priority
      75
    end

    # Explicitly redefine initialize to wipe the old "ghost" version from memory
    def initialize(mod)
      super(mod)
    end

    def available?(foe)
      # AOE Condition: swarmed by at least 2 mobs (mob2)
      # Use env.foes (correct API) instead of env.mobs
      return false unless self.env.foes.count >= 2

      # Mana check (m35)
      return false unless Char.mana >= 35

      # Specialize: Divine Wrath (335)
      return false unless Spell[335].known? and Spell[335].affordable?

      return true
    end

    def apply(foe)
      fput "incant 335"
      waitcastrt?
    end
  end
end