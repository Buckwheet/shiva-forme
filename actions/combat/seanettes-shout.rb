module Shiva
  class SeanettesShout < Action
    def priority
      Priority.get(:high)
    end

    def active?
      Effects::Buffs.active?("Empowered (+20)")
    end

    def available?
      Char.prof.eql?("Warrior") and
      not Effects::Debuffs.active?("Strained Muscles") and
      not cutthroat? and
      Char.stamina > 30 and
      not self.active?
    end

    def apply(_foe)
      fput "warcry sean"
      ttl = Time.now + 2
      wait_until {Effects::Buffs.active?("Empowered (+20)") or Time.now > ttl}
    end
  end
end