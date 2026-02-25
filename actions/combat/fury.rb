module Shiva
  class Fury < Action
    def priority
      41
    end

    def cost
      Effects::Buffs.active?("Stamina Second Wind") ? 0 : 15
    end

    def available?(foe)
      not Spell[506].active? and
      not Tactic.thrown? and
      not %i(duskruin).include?(self.env.name) and
      not foe.nil? and
      not Effects::Cooldowns.active?("Fury") and
      not Spell[117].active? and
      not Effects::Debuffs.active?("Jaws") and
      not hidden? and
      Tactic.can?(:brawling) and
      checkstamina > (self.cost * 3) and
      self.env.foes.size < 4
    end

    def fury(foe)
      Timer.await() if checkrt > 5
      Stance.offensive
      fput "weapon fury #%s" % foe.id
      ttl = Time.now + 5
      while line=get
        break if line.include?("...wait")
        break if line.include?("recentering yourself for the fight")
        break if line.include?("lose the rhythm of your assault")
        break unless GameObj[foe.id]
        break if foe.dead? or foe.gone?
        break if Time.now > ttl
      end
    end

    def apply(foe)
      return self.fury foe
    end
  end
end
