module Shiva
  class Web < Action
    def priority
      80
    end

    # Explicitly redefine initialize to wipe the old "ghost" version from memory
    def initialize(mod)
      super(mod)
    end

    def available?(foe)
      # Bigshot logic: !mob1 => Don't use if mobs > 1
      # Use env.foes (correct API) instead of env.mobs
      return false if self.env.foes.count > 1
      
      # Mana check (m5)
      return false unless Char.mana >= 5
      
      # Specialize: Web (118)
      return false unless Spell[118].known? and Spell[118].affordable?
      
      # Restriction: Only for Clerics and Empaths (as requested)
      return false unless %w(Cleric Empath).include?(Char.prof)

      # "Cycle until Stunned" Logic:
      return false if (foe.status.include?('prone') or 
                       foe.status.include?('lie') or 
                       foe.status.include?('lying') or
                       foe.status.include?('webbed'))

      return true
    end

    def apply(foe)
      fput "incant 118 ##{foe.id}"
      waitcastrt?
    end
  end
end