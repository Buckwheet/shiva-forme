module Shiva
  module Conditions
    module Burrowed
      LOGFILE = File.join(Dir.home, "gemstone", "shiva", "logs", "burrowed.log")

      def self.log(msg)
        FileUtils.mkdir_p(File.dirname(LOGFILE))
        File.open(LOGFILE, "a") { |f| f.puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')}] #{msg}" }
      end

      def self.snapshot
        {
          room_id:    XMLData.room_id,
          room_title: XMLData.room_title,
          debuffs:    Effects::Debuffs.to_h.keys,
          debuff_exp: Effects::Debuffs.to_h.map { |k, v| "#{k}=#{Time.at(v).strftime('%H:%M:%S') rescue v}" },
          health:     "#{checkhealth}/#{maxhealth}",
          stance:     checkstance,
          rt:         checkrt,
          foes:       GameObj.npcs.to_a.map { |f| "#{f.name}(##{f.id} status=#{f.status})" },
          hands:      "L=#{Char.left&.name || 'empty'} R=#{Char.right&.name || 'empty'}",
        }
      end

      def self.handle!
        active = Effects::Debuffs.active?("Burrowed")
        log "handle! called — active=#{active} caller=#{caller[0..2].join(' <- ')}"
        log "  snapshot: #{snapshot.inspect}" if active
        return unless active
        count = 0
        wait_while("waiting on burrowed...") do
          still = Effects::Debuffs.active?("Burrowed")
          count += 1
          log "  tick ##{count} still_active=#{still} room=#{XMLData.room_id} debuffs=#{Effects::Debuffs.to_h.keys}" if (count % 4) == 0
          still
        end
        log "handle! cleared after #{count} ticks (~#{count * 0.25}s)"
      end
    end
  end
end