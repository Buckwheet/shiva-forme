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
      # Search worn items and inside all containers
      all_items = GameObj.inv + GameObj.inv.flat_map { |c| c.contents || [] }
      
      if (dagger = all_items.find {|i| Tactic::Nouns::Dagger.include?(i.noun) })
        dagger.take if dagger.respond_to?(:take)
        return dagger
      end
      
      # Fallback: any edged weapon
      if (edged = all_items.find {|i| Tactic::Nouns::Edged.include?(i.noun) })
        edged.take if edged.respond_to?(:take)
        return edged
      end

      Echo.out "PANIC: No cutting weapon found for Belly of the Beast!", label: :shiva
      return nil
    end

    def apply
      waitrt?
      left, right = [Char.left, Char.right]
      if Config.briar_weapon && right
        dothistimeout "tap ##{right.id}", 5, /gently tap/
        waitrt?
        sleep 0.5
      end
      Containers.harness.add(left, right)
      dagger = self.find_dagger
      while XMLData.room_id.eql?(113001)
        fput "attack wall" if Char.right
        sleep 0.1
        waitrt?
      end
      fput "_drag #%s right" % right.id unless right.nil?
      fput "_drag #%s left" % left.id unless left.nil?
    end
  end
end