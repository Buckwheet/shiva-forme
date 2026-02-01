module Shiva
  class Main
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def make_decision
      Log.out("DEBUG: Calling env.best_action", label: :debug)
      (proposed_action, foe) = self.env.best_action
      Log.out("DEBUG: best_action returned: #{proposed_action}", label: :debug)
      
      # prevent followers from drive-by poaching
      if !Lich::Claim.mine? && !(Group.empty? || Group.leader?)
         Log.out("DEBUG: Claim check failed, returning :noop", label: :debug)
         return :noop 
      end

      Log.out("DEBUG: Calling Action.call(#{proposed_action})", label: :debug)
      Action.call(proposed_action, foe)
      sleep 0.1
      return proposed_action if proposed_action.is_a?(Symbol)
      proposed_action.to_sym
    end

    def apply()
      env.reset_start_time!

      loop {
        _ttl = Time.now + 0.1
        begin
            Log.out("DEBUG: Inside Main loop, calling make_decision...", label: :debug)
            action = self.make_decision()
            Log.out("DEBUG: Main loop action: #{action}", label: :debug)
            #Log.out(action, label: %i(previous action)) unless action.eql?(@previous_action)
            @previous_action = action
            break if @previous_action.eql?(:rest)
            sleep 0.1
        rescue Exception => e
            Log.out("CRITICAL EXCEPTION in Main Loop: #{e.message}", label: :error)
            Log.out(e.backtrace.join("\n"), label: :error)
            sleep 1
            break # Exit loop on error
        end
      }
    end
  end
end