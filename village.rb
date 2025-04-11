def load_items_from_file(filepath)
  items = []
  if File.exist?(filepath)
    file = File.open(filepath, 'r')
    while line = file.gets
      line = line.strip
      # Skip comments and empty lines
      next if line.empty? || line.start_with?('#')
      
      # Split the line into components
      parts = line.split(';')
      name = parts[0].strip
      stat = parts[1].strip.to_i
      cost = parts[2].strip.to_i
      
      items << { name: name, stat: stat, cost: cost }
    end
    file.close
  end
  items
end

def village_menu(inventory)
  weapons = load_items_from_file("data/shops/weapons.txt")
  armor = load_items_from_file("data/shops/armor.txt")

  while true
    puts "\n=== VILLAGE ==="
    puts "Gold: #{inventory["Gold"]}"
    puts "Swords"
    puts "Armor"
    puts "Enchant items"
    puts "Get a dog"
    puts "Leave"
    print "What would you like to browse? "

    choice = gets.chomp.downcase

    if choice == "leave"
      break
    elsif choice == "swords"
      shop_section("Swords", weapons, inventory, "Weapon")
    elsif choice == "armor"
      shop_section("Armor", armor, inventory, "Armor")
    elsif choice == "enchant" || choice == "enchant items"
      #placeholder for enchanting
      enchanting_menu(inventory)
      "wait, it no done yet"
    elsif choice == "get a dog" || choice == "dog"
      buy_item(inventory, "Pet", "Dog", 10)
    else
      puts "Invalid choice! Write Swords, Armor, or 'get a dog'. (Type 'leave' to exit)."
    end
  end
end

def enchanting_menu(inventory)
  while true
    puts "\n=== ENCHANTING ==="
    
    # Get weapon info
    weapon = nil
    keys = inventory.keys
    i = 0
    while i < keys.length
      if keys[i] == "Weapon"
        weapon = inventory[keys[i]]
      end
      i += 1
    end
    
    # Get damage
    damage = 0
    i = 0
    while i < keys.length
      if keys[i] == "WeaponDamage"
        damage = inventory[keys[i]].to_i
      end
      i += 1
    end
    
    # Get gold
    gold = 0
    i = 0
    while i < keys.length
      if keys[i] == "Gold"
        gold = inventory[keys[i]].to_i
      end
      i += 1
    end
    
    # Check if player has weapon
    has_weapon = true
    if weapon == nil
      has_weapon = false
    end
    if damage <= 0
      has_weapon = false
    end
    
    if has_weapon == false
      puts "You don't have a weapon to enchant!"
      break
    end
    
    # Calculate cost and enhancement
    cost = (damage * 3) / 10
    if damage / 10 == 0
      enchantment = 1
    else
    enhancement = damage / 10
    end
    
    puts "Current Weapon: #{weapon} (Damage: #{damage})"
    puts "Gold: #{gold}"
    puts "Enchanting Cost: #{cost} gold"
    puts "Damage Increase: +#{enhancement}"
    puts "1. Enchant Weapon"
    puts "0. Back to Village"
    print "Choose: "
    
    choice = gets.chomp
    
    if choice == "0"
      break
    end
    if choice == "1"
      if gold >= cost
        # Update gold
        new_gold = gold - cost
        i = 0
        while i < keys.length
          if keys[i] == "Gold"
            inventory[keys[i]] = new_gold.to_s
          end
          i += 1
        end
        
        # Update damage
        new_damage = damage + enhancement
        i = 0
        while i < keys.length
          if keys[i] == "WeaponDamage"
            inventory[keys[i]] = new_damage.to_s
          end
          i += 1
        end
        
        # Save to file
        file = File.open('inventory.txt', 'w')
        i = 0
        while i < keys.length
          file.puts "#{keys[i]}: #{inventory[keys[i]]}"
          i += 1
        end
        file.close
        
        puts "Your #{weapon} has been enchanted! New Damage: #{new_damage}"
      else
        puts "Not enough gold to enchant your weapon!"
      end
    else
      puts "Invalid choice!"
    end
  end
end


def shop_section(title, items, inventory, type)
  while true
    puts "\n=== #{title.upcase} ==="
    puts "Gold: #{inventory["Gold"]}"
    items.each_with_index do |item, index|
      puts "#{index + 1}. #{item[:name]} (#{item[:cost]} gold) - #{type == 'Weapon' ? 'Damage' : 'Protection'}: #{item[:stat]}"
    end
    puts "0. Back"
    print "Choose: "

    choice = gets.chomp

    if choice == "0" || choice.downcase == "back"
      b reak
    elsif choice.to_i > 0 && choice.to_i <= items.length
      selected_item = items[choice.to_i - 1]
      buy_item(inventory, type, selected_item[:name], selected_item[:cost], selected_item[:stat])
    else
      puts "Invalid choice! Use numbers or type 'back'"
    end
  end
end

def buy_item(inventory, type, item, price, stat = nil)
  gold = inventory["Gold"].to_i
  if gold >= price
    inventory["Gold"] = (gold - price).to_s

    # Update inventory with the purchased item and its stats
    if type == "Weapon"
      inventory["Weapon"] = item
      inventory["WeaponDamage"] = stat.to_s
    elsif type == "Armor"
      inventory["Armor"] = item
      inventory["Defense"] = stat.to_s
    elsif type == "Pet"
      inventory["Pet"] = item

    end

    # Write updated inventory to file
    File.open('inventory.txt', 'w') do |file|
      inventory.each do |key, value|
        file.puts "#{key}: #{value}"
      end
    end

    puts "You bought #{item}!"
  else
    puts "Not enough gold!"
  end
end