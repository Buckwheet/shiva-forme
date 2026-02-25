module Shiva
  class Brawl < Action
    def initialize(*args)
      super(*args)
      @action = "jab"
      @position = "decent"
      @tier3 = Config.brawl_tier3
      @last_foe_id = nil
    end

    def priority
      101
    end

    def available?(foe)
      not foe.nil? and
      (Tactic.brawling? or Config.brawling_weapon) and
      Tactic.can?(:brawling)
    end

    Followup  = /Strike leaves foe vulnerable to a followup (.*) attack!/
    Position  = /You have (decent|good|excellent) positioning/
    Endroll   = /d100: .* = \-?(\d+)$/
    Done      = /Roundtime:/

    def attack(foe)
      return if foe.dead? or foe.gone?
      waitrt?
      Stance.offensive
      fput "qstrike -2" if checkstamina > 40
      put "%s #%s" % [@action, foe.id]
      ttl = Time.now + 5
      while (line = get)
        if line =~ Position
          @position = $1
        elsif line =~ Followup
          @action = $1
          waitrt?
          attack(foe)
          return
        elsif line =~ Endroll
          endroll = $1.to_i
          hit = (endroll > 100 || endroll == 0)
          if hit
            @action = "jab" if @position != "excellent"
            @action = @tier3 if @position == "excellent" || @position == "good"
          end
        elsif line =~ /You fail to find an opening/
          @action = "jab"
          waitrt?
          attack(foe)
          return
        elsif line =~ /[wW]ait (\d+) sec/
          sleep $1.to_i
          attack(foe)
          return
        end
        break if line =~ Done
        break if foe.dead? or foe.gone?
        break if line =~ /What were you referring to|is already dead/
        break if Time.now > ttl
      end
    end

    def apply(foe)
      # Reset tier when switching targets
      if foe.id != @last_foe_id
        @action = "jab"
        @position = "decent"
        @last_foe_id = foe.id
      end
      attack(foe)
    end
  end
end
