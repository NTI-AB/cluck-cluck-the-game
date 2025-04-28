def choose_enemy(inventory)
  # Make sure we're reading the file correctly
  enemy_file_path = "data/enemies.txt"
  
  # Check if file exists
  unless File.exist?(enemy_file_path)
    puts "Error: Cannot find enemies file at #{enemy_file_path}"
    exit
  end
  
  # Read the file, skip comments and empty lines
  enemies = []
  File.foreach(enemy_file_path) do |line|
    line = line.chomp
    next if line.empty? || line.start_with?('#')
    enemies << line.split(';')
  end
  
  # Check if we got any enemies
  if enemies.empty?
    puts "Error: No enemies found in file"
    exit
  end
  
  # Select a random enemy
  enemy = enemies.sample
  
  # Make sure the enemy data has enough elements
  if enemy.length < 5
    puts "Error: Enemy data format is incorrect"
    exit
  end
  
  # Convert all numbers to integers
  i = 1
  while i < enemy.length
    enemy[i] = enemy[i].strip.to_i
    i += 1
  end
  
  # Reduce scaling to make early game easier
  player_phys = inventory["PhysicalDamage"].to_i
  player_magic = inventory["MagicDamage"].to_i
  average = (player_phys + player_magic) / 2
  
  # Gentler scaling for new characters
  if average <= 3
    # Almost no scaling for beginning characters
    enemy[1] += (average * 0.2).floor  # HP
    enemy[2] += (player_phys * 0.1).floor # Phys def
    enemy[3] += (player_magic * 0.1).floor # Magic def
  else
    # Normal scaling for stronger characters
    enemy[1] += (average * 0.5).floor  # HP
    enemy[2] += (player_phys * 0.2).floor # Phys def
    enemy[3] += (player_magic * 0.2).floor # Magic def
  end

  return enemy
end

# Helper function to save inventory to file
def save_inventory(inventory)
  File.open('inventory.txt', 'w') do |file|
    inventory.each do |key, value|
      file.puts "#{key}: #{value}"
    end
  end
end

def combat_encounter(inventory)
  enemy = choose_enemy(inventory)
  player_hp = 20
  
  puts "\nA #{enemy[0]} attacks!"
  puts "Enemy Stats: HP: #{enemy[1]} | Physical Defense: #{colorize(enemy[2].to_s, :yellow)} | Magic Defense: #{colorize(enemy[3].to_s, :blue)} | Attack: #{enemy[4]}"
  
  while true
    puts "\nYour HP: #{player_hp} | Enemy HP: #{enemy[1]}"
    puts "#{colorize('p', :yellow)} - Physical Attack (Your Damage: #{colorize(inventory["PhysicalDamage"].to_i.to_s, :yellow)})"
    puts "#{colorize('m', :blue)} - Magic Attack (Your Damage: #{colorize(inventory["MagicDamage"].to_i.to_s, :blue)})"
    puts "f - Flee"
    print "Choose: "
    
    choice = gets.chomp.downcase
    
    if choice == "attack" || choice == "p" || choice == "m"
      # Determine attack type
      if choice == "p" || choice == "attack"
        # Reduce enemy defense effect (was a direct subtraction)
        dmg = [inventory["PhysicalDamage"].to_i - (enemy[2] / 2), 1].max
        puts "You swing your weapon #{colorize('physically', :yellow)}!"
      else
        dmg = [inventory["MagicDamage"].to_i - (enemy[3] / 2), 1].max
        puts "You channel #{colorize('magical energy', :blue)}!"
      end
      
      enemy[1] -= dmg
      puts "You hit for #{dmg} damage!"
          
      if enemy[1] <= 0
        gold = inventory["Gold"].to_i + enemy[4] # Change to use enemy[4] for gold
        inventory["Gold"] = gold.to_s
        save_inventory(inventory)
        puts "You won! Got #{colorize(enemy[4].to_s + ' gold', :green)}"
        return
      end
      
      # Enemy attack - use enemy[4] for attack value
      damage_taken = [enemy[4] - inventory["Defense"].to_i, 1].max
      player_hp -= damage_taken
      puts "#{enemy[0]} hits you for #{damage_taken} damage!"
      
      if player_hp <= 0
        puts""
        puts "The #{enemy[0]} raises its weapon high, the final blow imminent."
        sleep(3)
        puts""
        puts "You try to lift your arms in defense, but your body betrays you."
        sleep(3)
        puts""
        puts "With a deafening roar, the #{enemy[0]} strikes you down, your wound #{colorize('gushing blood', :red)}"
        sleep(3)
        puts""
        puts "As darkness swallows you, you hear faint whispers of another chance..."
        sleep(3)
        puts""
        puts "Host healthpool has depleted, running isekai.exe"
        sleep(3)
        puts""
        puts""
        puts "You wake up in a field, confused and disoriented."
        sleep(3)
        puts""
        puts "Not knowing where you are, or how you got here, you begin exploring."
        
        # Load base inventory
        base_inventory = {}
        File.open('data/base_inventory.txt', 'r') do |file|
          while line = file.gets
            key, value = line.chomp.split(': ')
            base_inventory[key] = value
          end
        end
        
        # Write to inventory.txt
        save_inventory(base_inventory)
        
        exec("ruby #{$0}") # Restart the script
      end
    elsif choice == "flee" || choice == "f"
      lost = [inventory["Gold"].to_i, 3].min
      inventory["Gold"] = (inventory["Gold"].to_i - lost).to_s
      save_inventory(inventory)
      puts "Fled! Lost #{colorize(lost.to_s + ' gold', :red)}"
      return
    else
      puts "Invalid choice! Type #{colorize('p', :yellow)} for physical attack, #{colorize('m', :blue)} for magic attack, or 'f' to flee"
    end
  end
end