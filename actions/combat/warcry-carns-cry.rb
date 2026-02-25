module Shiva
  class CarnsCry < Action
    Immune = %w()
    Undead = %w(banshee ghast knight dreadsteed vampire fiend conjurer)
    
    def priority
      2
    end
    
    def cooldown
      @cooldown ||= Time.now
    end

    def available?(foe)
      # Check if targeting undead without Griffin's Voice rank 2+
      if Undead.include?(foe.noun) && CMan.griffin < 2
        return false
      end
      
      Char.prof.eql?("Warrior") and
      checkstamina > 50 and
      Time.now > self.cooldown and
      not Effects::Cooldowns.active?("Warcry") and
      self.env.foes.reject{|f| f.name =~ /spectral|ethereal|psionicist|siphon|destroyer/}.size > 1 and
      not foe.nil? and
      foe.status.empty? and
      not Immune.include?(foe.noun)
    end

    def carns_cry()
      Timer.await()
      waitrt?
      result = dothistimeout "warcry cry all", 5, Regexp.union(
        /is unaffected/,
        /looks at you in utter terror/,
        /wait/
      )
      
      # Add to immune list if unaffected
      if result =~ /is unaffected/
        self.env.foes.each do |f|
          Immune << f.noun unless Immune.include?(f.noun)
        end
      end
      
      @cooldown = Time.now + 60
      waitrt?
    end

    def apply(foe)
      return self.carns_cry
    end
  end
end