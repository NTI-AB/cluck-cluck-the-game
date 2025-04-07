def village_menu(inventory)
  while true
    puts "\n=== VILLAGE ==="
    puts "Gold: #{inventory["Gold"]}"  # This line shows current gold
    puts "1. Buy sword (15 gold)"
    puts "2. Buy armor (20 gold)"
    puts "3. Adopt dog (10 gold)"
    puts "0. Leave village"
    print "Choose: "
    
    choice = gets.chomp.to_i
    
    if choice == 0
      break
    elsif choice == 1
      buy_item(inventory, "Weapon", "Iron Sword", 15)
    elsif choice == 2
      buy_item(inventory, "Armor", "Leather Armor", 20)
    elsif choice == 3
      buy_item(inventory, "Pet", "Dog", 10)
    else
      puts "Invalid choice!"
    end
  end
end

def buy_item(inventory, type, item, price)
  gold = inventory["Gold"].to_i
  if gold >= price
    inventory["Gold"] = (gold - price).to_s
    inventory[type] = item
    File.open('inventory.txt', 'w') do |file|
      keys = inventory.keys
      i = 0
      while i < keys.length
        file.puts "#{keys[i]}: #{inventory[keys[i]]}"
        i += 1
      end
    end
    puts "Bought #{item}!"
  else
    puts "Not enough gold!"
  end
end