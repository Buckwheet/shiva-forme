# Dispel Magic
module Shiva
  class FeatDispel < Action
    Dispellable = %w(
      Web Calm Interference Bind Frenzy Condemn
      Weapon\ Deflection Elemental\ Saturation Slow Cold\ Snap Stone\ Fist Immolation
      Wild\ Entropy Sounds Holding\ Song Song\ of\ Depression Song\ of\ Rage
      Vertigo Confusion Thought\ Lash Mindwipe
      Pious\ Trial Aura\ of\ the\ Arkati
    )
    
    def priority
      -100
    end

    def cooldown
      @cooldown ||= Time.now
    end

    def debuffed?
      Dispellable.any? { |debuff| Effects::Debuffs.active?(debuff) }
    end

    def available?
      checkstamina > 40 and
      not Effects::Cooldowns.active?("Dispel Magic") and
      Feat.dispel_magic > 0 and
      Time.now > self.cooldown and
      self.debuffed?
    end

    def apply()
      waitcastrt?
      if self.debuffed?
        @cooldown = Time.now + 20
        fput "feat dispel"
      end
    end
  end
end