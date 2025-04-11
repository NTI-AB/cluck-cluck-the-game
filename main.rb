require_relative 'village'
require_relative 'combat'

def show_inventory(inventory)
  puts "\n=== INVENTORY ==="
  keys = inventory.keys
  i = 0
  while i < keys.length
    puts "#{keys[i]}: #{inventory[keys[i]]}"
    i += 1
  end
end

# Load initial inventory
inventory = {}
File.open('inventory.txt', 'r') do |file|
  while line = file.gets
    key, value = line.chomp.split(': ')
    inventory[key] = value
  end
end

# Main game loop
while true
  puts "\n=== MAIN MENU ==="
  puts "Go to village"
  puts "Fight enemy"
  puts "Check inventory"
  puts "Quit game"
  print "What would you like to do? "
  
  choice = gets.chomp.downcase
  
  if choice == "quit" || choice == "quit game"
    break
  elsif choice == "village" || choice == "go to village"
    village_menu(inventory)
  elsif choice == "fight" || choice == "fight enemy"
    combat_encounter(inventory)
  elsif choice == "inventory" || choice == "check inventory" || choice == "inv"
    show_inventory(inventory)
  else
    puts "Invalid choice! Try 'village', 'fight', or 'inventory'."
  end
end

def show_inventory(inventory)
  puts "\n=== INVENTORY ==="
  keys = inventory.keys
  i = 0
  while i < keys.length
    puts "#{keys[i]}: #{inventory[keys[i]]}"
    i += 1
  end
end