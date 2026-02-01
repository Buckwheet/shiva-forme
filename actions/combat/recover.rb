module Shiva
  class Recover < Action
    def priority
      100
    end

    def available?
      Shiva::DisarmTracker.active?
    end

    def apply
      item_noun = Shiva::DisarmTracker.item
      room_id = Shiva::DisarmTracker.room

      Log.out("Attempting to recover #{item_noun} in room #{room_id}", label: :warn)

      # 1. Go to the room if not there
      if Room.current.id != room_id
        Script.run("go2", room_id.to_s)
        waitrt?
      end
      
      # 2. Safety measures (Ecleanse style)
      if Spell[1011].known? && Spell[1011].affordable? && !Spell[1011].active?
        fput "incant 1011"
      elsif Spell[213].known? && Spell[213].affordable? && !Spell[213].active?
        fput "incant 213"
      end

      # 3. Recovery Loop
      5.times do
        if [GameObj.right_hand.noun, GameObj.left_hand.noun].include?(item_noun)
          Log.out("Weapon recovered!", label: :success)
          Shiva::DisarmTracker.reset!
          fput "stand" unless standing?
          return
        end

        fput "kneel" unless kneeling?
        result = dothistimeout "recover item", 2, /You spy|You find nothing|In order to recover|You continue to/
        
        if result =~ /You spy (?:an|a) (?:.*) and recover it\!/
          Log.out("Weapon recovered via message!", label: :success)
          Shiva::DisarmTracker.reset!
          fput "stand" unless standing?
          return
        end
        waitrt?
        sleep 0.5
      end
      
      # Final check
      if [GameObj.right_hand.noun, GameObj.left_hand.noun].include?(item_noun)
         Shiva::DisarmTracker.reset!
      else
         Log.out("FAILED TO RECOVER WEAPON!", label: :fatal)
         # Should we stop script?
         # Maybe not, but tracker remains active so it will keep trying?
      end
      fput "stand" unless standing?
    end
  end
end
