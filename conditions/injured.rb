module Shiva
  module Conditions
    module Injured
      def self.injured?
        # Calculate actual wound total
        total_wounds = XMLData.injuries.values.sum { |data| data["wound"] || 0 }
        
        # Ignore minor briar weapon wounds (total wounds 1 only)
        if Config.briar_weapon && total_wounds == 1 && percenthealth > 95
          return false
        end
        
        total_wounds > 0 or percenthealth < 100
      end

      def self.use_healer
        tries = 0
        begin
          tries = tries + 1
          wait_until("waiting on a healer...") {Team.has_healer?}
          sleep 5.0
          Team.request_healing
          ttl = Time.now + 10
          wait_while("waiting on injuries") {self.injured? and Time.now < ttl}
          fail "healing error" if Time.now > ttl
        rescue => exception
          fail exception if tries > 5
          retry
        end
      end

      def self.use_herbs
        # Tap briar weapon before eherbs to avoid damage
        if Config.briar_weapon
          weapon = GameObj.right_hand
          if weapon
            fput "tap ##{weapon.id}"
            waitrt?
          end
        end
        
        tries = 0
        begin
          tries = tries + 1
          Script.run("eherbs")
          waitrt?
          fail "could not heal down using ;eherbs" if self.injured?
        rescue => exception
          fail exception if tries > 2
          Script.run("eherbs", "stock")
        end
        waitrt?
      end

      def self.handle!
        return unless self.injured?
        Base.go2
        self.use_healer if Team.has_healer?
        
        if Script.exists?("eherbs") && Vars.herbsack && self.injured?
          Log.out("no healer connected...falling back to eherbs")
          self.use_herbs 
        end
      end
    end
  end
end