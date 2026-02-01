module Shiva
  module DisarmTracker
    @item = nil
    @room = nil
    @active = false

    def self.item
      @item
    end

    def self.room
      @room
    end

    def self.active?
      @active
    end

    def self.reset!
      @item = nil
      @room = nil
      @active = false
    end

    def self.init!
      Shiva::Hook.register("disarm_tracker") do |line|
        if line =~ /Your <a exist=".*?" noun="(.*?)">.*?<\/a> is knocked from your grasp/
          @item = $1
          @room = Room.current.id
          @active = true
        elsif line =~ /your <a exist="\d+?" noun="([^"]+)">.+?<\/a> at .+?\.  The weapon rebounds off of the hardened .+? and is wrenched from your hand\.  It slides along the ground and disappears into the shadows!\r?\n?$/
          @item = $1
          @room = Room.current.id
          @active = true
        elsif line =~ /^Your <a exist="\d+?" noun="([^"]+)">.+?<\/a> strikes one of the bony protrusions on <pushBold\/>an? <a exist="\d+" noun="[^"]+">[^<]+<\/a><popBold\/> \w+ and it is wrenched out of your grasp!\r?\n?$/
          @item = $1
          @room = Room.current.id
          @active = true
        elsif line =~ /^You swing your <a exist="[^"]+" noun="([^"]+)">[^<]+<\/a> at <pushBold\/>(?:an?|the) <a exist="[^"]+" noun="[^"]+">[^<]+<\/a><popBold\/>\.  The weapon strikes one of the bony protrusions on the <pushBold\/><a exist="[^"]+" noun="[^"]+">[^<]+<\/a><popBold\/> \w+ and it is wrenched out of your grasp!\r?\n?$/
          @item = $1
          @room = Room.current.id
          @active = true
        elsif line =~ /The webbing entangles your <a exist=".*?" noun="(.*?)">.*?<\/a>, rendering it useless/
           # Treat as disarm for now, though it might need pry logic
           @item = $1
           @room = Room.current.id
           @active = true
        end
        line
      end
    end
  end
end

Shiva::DisarmTracker.init!
