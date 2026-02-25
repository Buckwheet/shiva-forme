# The <a exist="430652426" noun="dirk">dirk</a> strikes true, but <pushBold/>the <a exist="430840899" noun="siphon">soul siphon</a><popBold/> shrugs off some of the damage!

module Shiva
  class SymbolOfBless < Action
    HookName    = "shiva/symbol-of-bless"
    NeedsBless  = Regexp.union(
      %r[The <a exist="(\d+)" noun="\w+">\w+<\/a> strikes true],
      %r[The <a exist="(\d+)" noun="\w+">\w+<\/a> strike true])
    Unblessable = %w(eonake white\ ora white\ alloy faewood veil\ iron kroderine)
    @@bless_queue = []

    def self.register()
      DownstreamHook.add(HookName, -> str {
        SymbolOfBless.parse(str)
        str
      })

      before_dying do DownstreamHook.remove(HookName) end
    end

    def self.parse(str)
      return unless @@bless_queue.empty?
      if result = str.match(NeedsBless)
        source_id = $1
        # Queue the source item (footwraps, fist, etc.)
        @@bless_queue.push(source_id)
        # Also queue the brawling weapon if configured and in hand
        if Config.brawling_weapon and Char.right and Char.right.name.eql?(Config.brawling_weapon)
          brawl_id = Char.right.id.to_s
          @@bless_queue.push(brawl_id) unless brawl_id == source_id
        end
        # Remove unblessable items
        @@bless_queue.reject! do |id|
          weapon = [Char.right, Char.left].compact.find { |w| w.id.to_s == id } ||
                   GameObj.inv.find { |obj| obj.id.to_s == id }
          weapon && Unblessable.any? { |mat| weapon.name =~ /#{mat}/i }
        end
      end
    end

    def self.id
      @@bless_queue.first.to_s
    end

    def self.weapon
      return nil if self.id.empty?
      return Char.right if Char.right.id.to_s.eql?(self.id)
      return Char.left if Char.left.id.to_s.eql?(self.id)
      GameObj.inv.find { |obj| obj.id.to_s.eql?(self.id) }
    end

    def self.owned?
      return false if Char.name.eql?("Szan")
      not self.weapon.nil?
    end

    def self.blessable?
      weapon = self.weapon
      return false if weapon.nil?
      Unblessable.none? { |material| weapon.name =~ /#{material}/i }
    end

    def self.needed?
      # Remove unblessable items we CAN identify; keep unrecognized IDs (worn footwraps)
      while @@bless_queue.any?
        w = self.weapon
        break if w.nil?            # can't find it (worn) — try to bless by ID anyway
        break if self.blessable?   # found and blessable
        @@bless_queue.shift        # found but unblessable — skip
      end
      @@bless_queue.any?
    end

    def self.reset!
      @@bless_queue.shift
    end

    def priority
      Priority.get(:high)
    end

    def available?
      Society.status.include?("Voln") and
      SymbolOfBless.needed?
    end

    def apply
      waitrt?
      fput "symbol of bless #%s" % SymbolOfBless.id
      SymbolOfBless.reset!
    end
  end

  SymbolOfBless.register()
end
