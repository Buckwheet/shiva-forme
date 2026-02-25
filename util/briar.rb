=begin
  Briar Weapon Protection
  
  Automatically taps briar weapons before storing to avoid damage.
  Loaded by Shiva when combat.briar_weapon = true
=end

before_dying do
  # Only run if Shiva's briar config is enabled
  next unless defined?(Shiva) && defined?(Config) && Config.briar_weapon rescue false
  
  weapon = GameObj.right_hand
  next unless weapon
  
  # Get the command that's about to execute
  line = get
  
  # Check if it's a command that will move the weapon
  if line =~ /^_drag\s+##{weapon.id}|^(?:put|stow|store)\s+(?:##{weapon.id}|weapon|both|all)/i
    # Tap weapon first
    fput "tap ##{weapon.id}"
    waitrt?
  end
  
  # Return the command to be executed
  line
end
