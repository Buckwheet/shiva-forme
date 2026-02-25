module Shiva
  class ShieldTrample < Action
    def priority
      5
    end

    def available?(foe)
      checkrt < 1 and
      not foe.nil? and
      not Effects::Debuffs.active?("Jaws") and
      not Effects::Cooldowns.active?("Shield Trample") and
      not Effects::Debuffs.active?("Sunder Shield") and
      checkstamina > 20 and
      not hidden? and
      self.env.foes.size > 2 and
      not foe.status.include?(:prone) and
      Tactic.shield? and
      Shield.trample > 0 and
      %w(Warrior Paladin).include?(Char.prof)
    end

    def shield_trample(foe)
      Timer.await() if checkrt > 5
      Stance.offensive
      fput "cman strample #%s" % foe.id
      sleep 0.5
      Timer.await() if checkrt > 6
    end

    def apply(foe)
      return self.shield_trample foe
    end
  end
end
