module Shiva
  class Smite < Action
    Uncrittable = %w(conjurer)
    Smited = []

    def self.smited?(foe)
      Smited.include?(foe.id)
    end

    def priority
      6
    end

    def available?(foe)
      Skills.brawling > Char.level * 1.5 and
      not Effects::Debuffs.active?("Jaws") and
      not Smited.include?(foe.id) and
      not Uncrittable.include?(foe.noun) and
      (Char.prof =~ /Rogue/ ? hidden? : true) and
      foe.type.include?("noncorporeal")
    end

    Ok = Regexp.union(
      /is held in the corporeal plane!/,
      /is unwillingly drawn into the corporeal plane/,
    )

    def apply(foe)
      waitrt?
      Stance.offensive
      put "smite #%s" % foe.id
      ttl = Time.now + 4
      while (line = get)
        if line =~ Ok
          Smited << foe.id
          break
        elsif line =~ /[wW]ait (\d+) sec/
          sleep $1.to_i
          put "smite #%s" % foe.id
        end
        break if line =~ /Roundtime:/
        break if foe.dead? or foe.gone?
        break if line =~ /What were you referring to|is already dead/
        break if Time.now > ttl
      end
    end
  end
end
