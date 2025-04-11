def choose_enemy
enemies_from_file = File.readlines("data/enemies.txt")[1..].map { |line| line.chomp.split(";") }

p enemies_from_file

enemy = enemies_from_file.sample

i = 1
  while i < enemy.length
    enemy[i] = enemy[i].to_i
    i += 1
  end
  return enemy

end


def combat_encounter(inventory)
  enemy = choose_enemy()
  player_hp = 20
  base_damage = inventory["WeaponDamage"].to_i
  
  puts "\nA #{enemy[0]} attacks!"
  
  while true
    puts "\nYour HP: #{player_hp} | Enemy HP: #{enemy[1]}"
    puts "Attack"
    puts "Flee"
    print "Choose: "
    
    choice = gets.chomp.downcase
    
    if choice == "attack"
      # Player attack
      enemy[1] -= base_damage
      puts "You hit for #{base_damage} damage!"
      
      if enemy[1] <= 0
        gold = inventory["Gold"].to_i + enemy[3]
        inventory["Gold"] = gold.to_s
        File.open('inventory.txt', 'w') do |file|
          keys = inventory.keys
          i = 0
          while i < keys.length
            file.puts "#{keys[i]}: #{inventory[keys[i]]}"
            i += 1
          end
        end
        puts "You won! Got #{enemy[3]} gold"
        return
      end
      
      # Enemy attack
      damage_taken = [enemy[2] - inventory["Defense"].to_i, 1].max
      player_hp -= damage_taken
      puts "#{enemy[0]} hits you for #{damage_taken} damage!"
      
      if player_hp <= 0
        puts "You died!"
        exit
      end
    elsif choice == "flee"
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
      puts "Invalid choice! Type 'attack' or 'flee'"
    end
  end
end