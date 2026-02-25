# Absorb Magic

module Shiva
  class FeatAbsorb < Action
    def priority
      Priority.get(:high)
    end

    def available?
      not Effects::Buffs.active?("Absorb Magic") and
      not Effects::Cooldowns.active?("Absorb Magic") and
      not Effects::Debuffs.active?("Sympathy") and
      Feat.absorb_magic > 0 and
      not checkstunned and
      not self.env.foes.empty?
    end

    def apply()
      waitcastrt?
      dothistimeout "feat absorb", 2, /ravenous void|stubbornly out of reach|wait/
    end
  end
end