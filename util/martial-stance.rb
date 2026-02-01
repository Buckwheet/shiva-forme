module Shiva
  module Martial
    module Stance
      def self.use(name, cmd)
        return if name.eql?(:noop)
        if Effects::Spells.active?(name)
           Log.out("Stance #{name} is already active.", label: :debug)
           return
        end
        Log.out("Switching to stance: #{name} (cmd: #{cmd})", label: :debug)
        waitrt?
        put "cman %s" % cmd
      end

      def self.offensive_martial_stance()
        Log.out("Selecting offensive stance... Dervish: #{CMan.whirling_dervish}, Predator: #{CMan.predators_eye}", label: :debug)
        return ["Whirling Dervish", "dervish"] if CMan.whirling_dervish && $shiva.env.foes.size > 1 && GameObj.left_hand.type.include?("weapon")
        return ["Predator's Eye", "predator"]  if CMan.predators_eye > 0
        return [:noop, nil]
      end

      def self.defensive_martial_stance()
        Log.out("Selecting defensive stance... Slippery: #{CMan.slippery_mind}, Duck: #{CMan.duck_and_weave}", label: :debug)
        return ["Slippery Mind", "slippery"] if CMan.slippery_mind > 0
        return ["Duck and Weave", "duck"]    if CMan.duck_and_weave > 0
        Log.out("No defensive stance found.", label: :debug)
        return [:noop, nil]
      end

      def self.swap()
        Log.out("Starting stance swap...", label: :debug)
        self.use(*self.offensive_martial_stance)
        yield
        
        # Only switch back to defensive if in Scale Armor (free cost)
        unless Shiva::Armor.scale?
          Log.out("Armor is not Scale. Staying in offensive stance.", label: :debug)
          return
        end

        Log.out("Swap yielding finished. Switching to defensive.", label: :debug)
        self.use(*self.defensive_martial_stance)
      end
    end
  end
end