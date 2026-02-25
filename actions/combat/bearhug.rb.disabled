module Shiva
  class Bearhug < Action
    Immune = %w()

    def priority
      6
    end

    def cost
      Effects::Buffs.active?("Stamina Second Wind") ? 0 : 10
    end

    def available?(foe)
      not foe.nil? and
      CMan.bearhug > 0 and
      not Effects::Cooldowns.active?("Bearhug") and
      checkstamina > (self.cost * 3) and
      not foe.status.include?('prone') and
      not foe.status.include?('lying') and
      not Immune.include?(foe.noun)
    end

    def bearhug(foe)
      Timer.await() if checkrt > 5
      Stance.offensive
      result = dothistimeout "cman bearhug #%s" % foe.id, 1, Regexp.union(
        /You cannot bearhug/,
        /charges towards/,
        /still in cooldown/,
        /wait/
      )
      if result =~ /You cannot bearhug/
        Immune << foe.noun unless Immune.include?(foe.noun)
      elsif result =~ /charges towards/
        # Wait for bearhug to complete
        ttl = Time.now + 20
        while line = get
          break if line =~ /releases.*grip|crumple to the ground|breaks free/
          break if Time.now > ttl
        end
      end
      sleep 0.5
      Timer.await() if checkrt > 6
    end

    def apply(foe)
      return self.bearhug foe
    end
  end
end
