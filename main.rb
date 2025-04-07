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
  puts "1. Go to village"
  puts "2. Fight enemy"
  puts "3. Check inventory"
  puts "0. Quit game"
  print "Choose: "
  
  choice = gets.chomp.to_i
  
  if choice == 1
    village_menu(inventory)
  elsif choice == 2
    combat_encounter(inventory)
  elsif choice == 3
    show_inventory(inventory)
  elsif choice == 0
    break
  else
    puts "Invalid choice!"
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