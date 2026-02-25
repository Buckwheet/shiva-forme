module Shiva
  class Clash < Action
    def priority
      5
    end

    def available?(foe)
      not Spell[506].active? and
      not Effects::Cooldowns.active?("Clash") and
      not self.env.foes.any? {|f| %w(brawler).include?(f.noun)} and
      Tactic.can?(:brawling) and
      checkstamina > 50 and
      not hidden? and
      self.env.foes.size > 2 and
      not foe.nil? and
      rand > 0.6
    end

    def clash(foe)
      Timer.await() if checkrt > 5
      Stance.offensive
      fput "weapon clash"
    end

    def apply(foe)
      return self.clash foe
    end
  end
end
