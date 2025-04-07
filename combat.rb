def combat_encounter(inventory)
  enemies = [
    { name: "Bandit", hp: 10, attack: 2, gold: 5 },
    { name: "Wolf", hp: 8, attack: 3, gold: 3 }
  ]
  enemy = enemies.sample
  
  player_hp = 20
  weapon_damage = { "Rusty Dagger" => 2, "Iron Sword" => 5 }
  base_damage = weapon_damage[inventory["Weapon"]] || 1
  
  puts "\nA #{enemy[:name]} attacks!"
  
  while true
    puts "\nYour HP: #{player_hp} | Enemy HP: #{enemy[:hp]}"
    puts "1. Attack"
    puts "2. Flee"
    print "Choose: "
    
    choice = gets.chomp.to_i
    
    if choice == 1
      # Player attack
      enemy[:hp] -= base_damage
      puts "You hit for #{base_damage} damage!"
      
      if enemy[:hp] <= 0
        gold = inventory["Gold"].to_i + enemy[:gold]
        inventory["Gold"] = gold.to_s
        File.open('inventory.txt', 'w') do |file|
          keys = inventory.keys
          i = 0
          while i < keys.length
            file.puts "#{keys[i]}: #{inventory[keys[i]]}"
            i += 1
          end
        end
        puts "You won! Got #{enemy[:gold]} gold"
        return
      end
      
      # Enemy attack
      player_hp -= enemy[:attack]
      puts "#{enemy[:name]} hits you for #{enemy[:attack]} damage!"
      
      if player_hp <= 0
        puts "You died!"
        exit
      end
    elsif choice == 2
      lost = [inventory["Gold"].to_i, 3].min
      inventory["Gold"] = (inventory["Gold"].to_i - lost).to_s
      File.open('inventory.txt', 'w') do |file|
        keys = inventory.keys
        i = 0
        while i < keys.length
          file.puts "#{keys[i]}: #{inventory[keys[i]]}"
          i += 1
        end
      end
      puts "Fled! Lost #{lost} gold"
      return
    else
      puts "Invalid choice!"
    end
  end
end