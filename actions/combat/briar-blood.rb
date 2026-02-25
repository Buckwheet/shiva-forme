module Shiva
  class BriarBlood < Action
    def priority
      Priority.get(:high)
    end

    def available?(foe)
      Config.briar_weapon and
      not Spell[9105].active? and
      checkrt < 1 and
      self.briar_ready?
    end

    def briar_ready?
      weapon = GameObj.right_hand
      return false unless weapon
      
      silence_me unless (undo_silence = silence_me)
      res = Lich::Util.quiet_command_xml("measure ##{weapon.id}", /^You gaze intently|^Now, why are you trying to measure/, /<prompt time=/)
      ready = false
      if res.any? { |line| line =~ /to be about (\d+) percent\./i }
        ready = true if $1.to_i == 100
      end
      silence_me if undo_silence
      
      ready
    end

    def apply(foe)
      weapon = GameObj.right_hand
      return :noop unless weapon
      
      Log.out("Activating briar blood (#{weapon.name})", label: :combat)
      fput "raise ##{weapon.id}"
      sleep 0.5
      
      :ok
    end
  end
end
