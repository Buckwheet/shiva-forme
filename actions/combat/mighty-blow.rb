module Shiva
  class MightyBlow < Action
    def priority
      100
    end

    def cost
      Effects::Buffs.active?("Stamina Second Wind") ? 0 : 15
    end

    def available?(foe)
      not foe.nil? and
      CMan.mblow > 0 and
      checkstamina > (self.cost * 3) and
      (Tactic.edged? or Tactic.respond_to?(:blunt?) && Tactic.blunt? or Tactic.respond_to?(:twohanded?) && Tactic.twohanded?) and
      not Tactic.polearms?
    end

    def apply(foe)
      Stance.offensive
      fput "cman mblow"
      Timer.await()
    end
  end
end
