module Shiva
  module Armor
    def self.inspect!(item)
      # Match the line containing the conclusion results
      res = dothistimeout "inspect ##{item.id}", 3, /allows you to conclude/
      if res =~ /it is (.*?) armor/
        return $1.downcase
      else
        return :unknown
      end
    end

    def self.detect
      # 1. Use configured armor if available
      armor_name = Config.armor
      armor = nil

      if armor_name
        # Find item matching configured name (noun or full name)
        armor = GameObj.inv.find {|item| item.name =~ /#{Regexp.escape(armor_name)}/i || item.noun =~ /#{Regexp.escape(armor_name)}/i }
        Log.out("Configured armor '#{armor_name}' not found in inventory!", label: :warn) unless armor
      end

      # 2. Fallback: Scan for 'armor' type if not found
      unless armor
        Log.out("DEBUG: Config.armor is #{armor_name.inspect}. Fallback scanning active.", label: :debug)
        Log.out("Scanning inventory for any armor...", label: :setup) if armor_name
        
        # Blacklist common accessories that are tagged as armor but aren't the main suit
        blacklist = %w(aventail helm greaves bracer armguards leg-guards shield buckler targe)
        
        armor = GameObj.inv.find {|item| 
          item.type =~ /armor/i && !blacklist.include?(item.noun.downcase)
        } 
      end
      
      if armor.nil?
         Log.out("Shiva::Armor: Could not find any worn armor!", label: :fatal)
         Log.out("Please set 'combat.armor' in your config or double-check your inventory.", label: :fatal)
         exit
      end
      
      # 3. Inspect it
      Log.out("Inspecting armor: #{armor.name}", label: :setup)
      $shiva_armor_type = self.inspect!(armor)
      
      Log.out("Armor detected: #{$shiva_armor_type}", label: :setup)
      
      # 3. Handle failure logic as requested ("exit shiva if not found")
      if $shiva_armor_type == :unknown
        Log.out("Could not determine armor type. Exiting.", label: :fatal)
        exit
      end
      
      $shiva_armor_type
    end

    def self.scale?
      return false if $shiva_armor_type.nil?
      
      # User correction: Inspect only returns main ASG types (e.g. "scale armor").
      # Sub-types like "studded" or "brigandine" normalized to "scale".
      $shiva_armor_type.include?("scale")
    end
    
    # Setup hook
    def self.init
      self.detect unless $shiva_armor_type
    end
  end
end
