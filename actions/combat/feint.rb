module Shiva
  class Feint < Action
    def priority
      4
    end

    def use_growl?
      Warcry["growl"] > 0 and CMan.griffin >= 2
    end

    def cooldown
      @cooldown ||= Time.now
    end

    def available?(foe)
      not foe.nil? and
      checkstamina > 20 and
      if use_growl?
        Warcry.available?("growl") and
        Time.now > self.cooldown
      else
        not self.env.seen.include?(foe.id) and
        CMan.feint > 3
      end
    end

    def apply(foe)
      if use_growl?
        waitrt?
        if self.env.foes.size > 1
          dothistimeout "warcry growl all", 5, /overcome with|forced into|unaffected|wait/
        else
          dothistimeout "warcry growl #%s" % foe.id, 5, /overcome with|forced into|unaffected|wait/
        end
        @cooldown = Time.now + 30
        waitrt?
      else
        Timer.await() if checkrt > 5
        Stance.offensive
        fput "cman feint #%s" % foe.id
        self.env.seen << foe.id
      end
    end
  end
end
