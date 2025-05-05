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
      phys = parts[1].strip.to_i
      magic = parts[2].strip.to_i
      cost = parts[3].strip.to_i

      items << { name: name, phys: phys, magic: magic, cost: cost }
      
    end
    file.close
  end
  items
end

# Helper function to save inventory to file
def save_inventory(inventory)
  File.open('inventory.txt', 'w') do |file|
    inventory.each do |key, value|
      file.puts "#{key}: #{value}"
    end
  end
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
      enchanting_menu(inventory)
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
    
    # Get current stats
    phys_dmg = inventory["PhysicalDamage"].to_i
    magic_dmg = inventory["MagicDamage"].to_i
    armor_def = inventory["Defense"].to_i
    gold = inventory["Gold"].to_i

    # Calculate costs
    phys_cost = (phys_dmg * 3) / 10  # 30% base
    phys_cost += 1 if (phys_dmg * 3) % 10 != 0  # Round up
    
    magic_cost = (magic_dmg * 3) / 10
    magic_cost += 1 if (magic_dmg * 3) % 10 != 0
    
    armor_cost = (armor_def * 3) / 10
    armor_cost += 1 if (armor_def * 3) % 10 != 0

    # Calculate bonuses
    phys_bonus = phys_dmg / 10  # 10% base
    phys_bonus = 1 if phys_bonus == 0
    
    magic_bonus = magic_dmg / 10
    magic_bonus = 1 if magic_bonus == 0
    
    armor_bonus = armor_def / 10
    armor_bonus = 1 if armor_bonus == 0

    puts "1. Enhance #{colorize('Physical', :yellow)} (+#{phys_bonus}) - #{colorize(phys_cost.to_s + ' gold', :green)}"
    puts "2. Enhance #{colorize('Magic', :blue)} (+#{magic_bonus}) - #{colorize(magic_cost.to_s + ' gold', :green)}" 
    puts "3. Enhance Armor (+#{armor_bonus}) - #{colorize(armor_cost.to_s + ' gold', :green)}"
    puts "0. Back"
    print "Choose: "

    # Rest of the function remains the same
    choice = gets.chomp

    case choice
    when "1"
      if gold >= phys_cost
        inventory["Gold"] = (gold - phys_cost).to_s
        inventory["PhysicalDamage"] = (phys_dmg + phys_bonus).to_s
        puts "Physical enhanced! New: #{colorize(inventory["PhysicalDamage"], :yellow)}"
        save_inventory(inventory)
      else
        puts "Not enough gold!"
      end
    when "2"
      if gold >= magic_cost
        inventory["Gold"] = (gold - magic_cost).to_s
        inventory["MagicDamage"] = (magic_dmg + magic_bonus).to_s
        puts "Magic enhanced! New: #{colorize(inventory["MagicDamage"], :blue)}"
        save_inventory(inventory)
      else
        puts "Not enough gold!"
      end
    when "3"
      if gold >= armor_cost
        inventory["Gold"] = (gold - armor_cost).to_s
        inventory["Defense"] = (armor_def + armor_bonus).to_s
        puts "Armor enhanced! New: #{inventory["Defense"]}"
        save_inventory(inventory)
      else
        puts "Not enough gold!"
      end
    when "0"
      break
    else
      puts "Invalid choice!"
    end
  end
end
    
def shop_section(title, items, inventory, type)
  while true
    puts "\n=== #{title.upcase} ==="
    puts "Gold: #{colorize(inventory["Gold"], :green)}"
    items.each_with_index do |item, index|
      phys_stats = colorize("Phys: #{item[:phys]}", :yellow)
      magic_stats = colorize("Magic: #{item[:magic]}", :blue) if item[:magic]
      stats = type == "Weapon" ? "#{phys_stats}, #{magic_stats}" : phys_stats
      puts "#{index + 1}. #{item[:name]} (#{colorize(item[:cost].to_s + ' gold', :green)}) - #{stats}"
    end
    puts "0. Back"
    print "Choose: "

    # Rest of function remains the same
    choice = gets.chomp

    if choice == "0" || choice.downcase == "back"
      break
    elsif choice.to_i > 0 && choice.to_i <= items.length
      selected_item = items[choice.to_i - 1]
      if type == "Weapon"
        buy_item_with_stats(inventory, type, selected_item[:name], selected_item[:cost], selected_item[:phys], selected_item[:magic])
      elsif type == "Armor"
        buy_item_with_stats(inventory, type, selected_item[:name], selected_item[:cost], selected_item[:phys])
      end
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
      inventory["PhysicalDamage"] = stat[:phys].to_s
      inventory["MagicDamage"] = stat[:magic].to_s
    elsif type == "Armor"
      inventory["Armor"] = item
      inventory["Defense"] = stat.to_s
    elsif type == "Pet"
      inventory["Pet"] = item
    end

    # Save inventory to file
    save_inventory(inventory)

    puts "You bought #{item}!"
  else
    puts "Not enough gold!"
  end
end

def buy_item_with_stats(inventory, type, item, price, phys, magic = nil)
  gold = inventory["Gold"].to_i
  if gold >= price
    inventory["Gold"] = (gold - price).to_s

    # Update inventory with the purchased item and its stats
    if type == "Weapon"
      inventory["Weapon"] = item
      inventory["PhysicalDamage"] = phys.to_s
      inventory["MagicDamage"] = magic.to_s
    elsif type == "Armor"
      inventory["Armor"] = item
      inventory["Defense"] = phys.to_s
    end

    # Save inventory to file
    save_inventory(inventory)

    puts "You bought #{item}!"
  else
    puts "Not enough gold!"
  end
end