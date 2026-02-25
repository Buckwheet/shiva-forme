module Hand
  def self.apply(side)
    waitrt?
    hand = Char.send(side)
    unless hand.nil?
      # Tap briar weapon before storing to retract briars
      if Config.briar_weapon && side == :right
        dothistimeout "tap ##{hand.id}", 5, /gently tap/
        waitrt?
        sleep 0.5
      end
      
      5.times { 
        Containers.harness.add(hand)
        break if Char.send(side).nil?
      }
    end
    yield(side)
    unless hand.nil?
      5.times {
        Containers.harness.where(id: hand.id).first.take
        break if Char.send(side).id.eql?(hand.id)
      }
    end
  end

  def self.right(&block)
    self.apply(:right, &block)
  end

  def self.left(&block)
    self.apply(:left, &block)
  end

  def self.use(&block)
    return self.left(&block) if GameObj.inv.map(&:name).include?("enormous eonake gauntlet")
    return self.right(&block) if Tactic.ranged? or Tactic.shield?
    self.left(&block)
  end

  def self.both()
    waitrt?
    left, right = [Char.left, Char.right]
    
    # Tap briar weapon before storing
    if Config.briar_weapon && right
      dothistimeout "tap ##{right.id}", 5, /gently tap/
      waitrt?
      sleep 0.5
    end
    
    Containers.harness.add(left, right)
    yield
    fput "_drag #%s right" % right.id unless right.nil?
    fput "_drag #%s left" % left.id unless left.nil?
  end
end