module Shiva
  class ShieldBash < Action
    Immune = %w(crawler cerebralite golem)

    def priority
      (5...9).to_a.sample
    end

    def cost
      Effects::Buffs.active?("Stamina Second Wind") ? 0 : 9
    end

    def foe_down?(foe)
      foe.status.any? { |s| s.to_s =~ /prone|lying|knocked|down/i }
    end

    def available?(foe)
      not foe.nil? and
      Shield.bash > 2 and
      checkstamina > (self.cost * 6) and
      not foe_down?(foe) and
      @last_bashed != foe.id and
      not Immune.include?(foe.noun) and
      Char.left.name =~ /kroderine|veil iron/i
    end

    def shield_bash(foe)
      return if foe_down?(foe)
      return if @last_bashed == foe.id
      Stance.offensive
      result = dothistimeout "shield bash #%s" % foe.id, 1, Regexp.union(
        %r`You lunge forward`,
        %r`would be a rather awkward proposition`,
        %r`wait`
      )
      if result =~ /rather awkward proposition/
        Immune << foe.noun unless Immune.include?(foe.noun)
      end
      @last_bashed = foe.id if result =~ /You lunge forward/
      sleep 0.5
      Timer.await() if checkrt > 6
    end

    def apply(foe)
      return self.shield_bash foe
    end
  end
end