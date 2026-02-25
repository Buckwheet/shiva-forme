module Shiva
  class Kill < Action
    def initialize(*args)
      super(*args)
      @aim_misses = {}  # track consecutive aimed misses per foe id
    end

    def priority
      101
    end

    def available?(foe)
      not foe.nil? and
      self.env.foes.size > 0 and
      (Tactic.edged? or Tactic.polearms?) and 
      Lich::Claim.mine?
    end

    def get_best_area(foe)
      # fall back to unaimed after 2 consecutive misses on same target
      if (@aim_misses[foe.id] || 0) >= 2
        @area = "clear"
        return @area
      end
      proposed_area = foe.kill_shot Aiming.lookup(foe) rescue "clear"
      Log.out("{foe=%s, aim=%s}" % [foe.name, @area])
      @area = proposed_area
      return @area
    end

    def kill(foe)
      Stance.offensive
      if Skills.ambush < 25 || (foe.tall? && !foe.status.include?(:prone)) || foe.type.include?("noncorporeal")
        put "attack #%s clear" % foe.id
      else
        area = self.get_best_area(foe)
        area = "clear" if %w(chest back).include?(area.to_s)
        put "attack #%s %s" % [foe.id, area]
      end
      result = Timer.await()
      if result =~ /fail to find an opening/i
        @aim_misses[foe.id] = (@aim_misses[foe.id] || 0) + 1
      else
        @aim_misses.delete(foe.id)
      end
    end

    def apply(foe)
      return self.kill foe
    end
  end
end