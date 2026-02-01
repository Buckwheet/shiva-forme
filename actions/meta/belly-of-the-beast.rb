=begin
  You catch one last glimpse of your surroundings as darkness closes in on you...
[The Belly of the Beast - ] (u113001)
You notice the crawler's stomach wall.
Obvious exits: none
=end

module Shiva
  class BellyOfTheBeast < Action
    def priority
      -1000
    end

    def available?
      XMLData.room_id.eql? 113001
    end

    def find_dagger
      # Search Configured Skinning Weapon first (Likely a dagger)
      if defined?(Config) and Config.respond_to?(:skinning_weapon) and Config.skinning_weapon
         candidates = [Containers.harness, Containers.lootsack].compact
         found = candidates.map {|c| c.find { |i| i.name.eql?(Config.skinning_weapon) } }.compact.first
         if found
           found.take
           return found
         end
      end

      # Search Priority 1: Daggers (User requested/believed requirement)
      if (dagger = [Containers.harness, Containers.lootsack].compact.map {|c| c.find {|i| Tactic::Nouns::Dagger.include?(i.noun) } }.compact.first)
        dagger.take
        return dagger
      end
      
      # Search Priority 2: Any Edged (Desperation fallback - better to try than die)
      if (edged = [Containers.harness, Containers.lootsack].compact.map {|c| c.find {|i| Tactic::Nouns::Edged.include?(i.noun) } }.compact.first)
        edged.take
        return edged
      end

      Echo.out "PANIC: No cutting weapon found for Belly of the Beast! Looked for Daggers then Edged.", label: :shiva
      return nil
    end

    def apply
      Char.unarm
      waitrt?
      dagger = self.find_dagger
      while XMLData.room_id.eql?(113001)
        # Attack with whatever we found (Dagger or Fallback)
        fput "attack wall" if Char.right
        sleep 0.1
        waitrt?
      end
      Containers.harness.add(dagger) if dagger
      Char.arm
    end
  end
end