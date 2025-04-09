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
  
  
  #Name;hp;attack damage; gold drop on death
  enemy = choose_enemy()
  #p enemy

  player_hp = 20
  weapon_damage = { "Rusty Dagger" => 2, "Iron Sword" => 5 }
  base_damage = weapon_damage[inventory["Weapon"]] || 1
  
  puts "\nA #{enemy[0]} attacks!"
  
  while true
    puts "\nYour HP: #{player_hp} | Enemy HP: #{enemy[1]}"
    puts "1. Attack"
    puts "2. Flee"
    print "Choose: "
    
    choice = gets.chomp.to_i
    
    if choice == 1
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
      player_hp -= enemy[2]
      puts "#{enemy[0]} hits you for #{enemy[2]} damage!"
      
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