module Shiva
  class Teardown
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def turn_in_bounty(town)
      return :not_allowed unless Group.empty?
      return :skip if %i(cull dangerous heirloom).include?(Bounty.type)
      return :skip if %i(gem skin).include?(Bounty.type) and Task.sellables.empty?
      Task.advance(town)
    end

    def others?
      (GameObj.pcs.to_a.map(&:noun) - Cluster.connected).size > 0
    end

    def box?
      GameObj.loot.any? {|i| i.type =~ /box/}
    end

    def box_routine(town = nil)
      Char.unarm
      Log.out("running box routine...")
      return Boxes.drop if Boxes.picker?
      Shiva.stockpile_gems!
      Task.room(town, "advguild").id.go2 unless town.nil?
      Script.run("eloot", "sell") if Script.exists?("eloot")
      Script.run("shiva_teardown") if Script.exists?("shiva_teardown")
      Base.go2
    end

    def report()
      _respond "<b>resting because of %s</b>" % $shiva_rest_reason
    end

    def cleanup(town)
      Rally.group(Base.closest) if Group.leader? and not Group.empty?
      self.turn_in_bounty(town) if %i(report_to_guard skin heirloom_found).include? Bounty.type
      Base.go2
      
      # Calculate actual wound total
      total_wounds = XMLData.injuries.values.sum { |data| data["wound"] || 0 }
      
      # Skip healing if only briar wound
      unless Config.briar_weapon && total_wounds == 1 && percenthealth > 95
        Conditions::Injured.handle!
      end
      
      # Ignore minor briar wounds (total wounds 1 with high health)
      wait_while("cleanup:waiting on healing") do
        total_wounds = XMLData.injuries.values.sum { |data| data["wound"] || 0 }
        if Config.briar_weapon && total_wounds == 1 && percenthealth > 95
          false
        else
          total_wounds > 1
        end
      end
      Char.unarm
      
      wait_while("waiting on hands") {Char.left or Char.right} unless Char.left.type =~ /box/
      
      self.box_routine(town)
      
      if Bounty.type.eql?(:gem) and Task.sellables.size > 0
        self.turn_in_bounty(town)
        Base.go2
      end
      
      self.report
    end

    def apply()
      self.cleanup(self.env.town) if self.env.town
    end
  end
end