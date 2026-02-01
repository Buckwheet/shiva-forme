module Shiva
  class Condemn < Action
    def priority
      70
    end

    # Explicitly redefine initialize to wipe the old "ghost" version from memory
    def initialize(mod)
      super(mod)
    end

    def available?(foe)
      # Bigshot logic: !mob1 => Only use if mobs <= 1 (Single Target Focus)
      # Use env.foes (correct API) instead of env.mobs
      return false if self.env.foes.count > 1

      # Mana check (m5)
      return false unless Char.mana >= 5

      # Specialize: Condemn (309)
      return false unless Spell[309].known? and Spell[309].affordable?

      return true
    end

    def apply(foe)
      fput "incant 309 ##{foe.id}"
      waitcastrt?
    end
  end
end