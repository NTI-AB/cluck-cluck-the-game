require_relative 'village'
require_relative 'combat'

COLORS = {
  red: "\e[31m",
  green: "\e[32m",
  yellow: "\e[33m",  # This will represent orange
  blue: "\e[34m",
  magenta: "\e[35m",
  cyan: "\e[36m",
  reset: "\e[0m"
}

def colorize(text, color)
  "#{COLORS[color]}#{text}#{COLORS[:reset]}"
end

def show_inventory(inventory)
  puts "\n=== INVENTORY ==="
  keys = inventory.keys
  i = 0
  while i < keys.length
    value = inventory[keys[i]]
    # Color code based on key type
    if keys[i] == "PhysicalDamage"
      value = colorize(value, :yellow)
    elsif keys[i] == "MagicDamage"
      value = colorize(value, :blue)
    elsif keys[i] == "Gold"
      value = colorize(value, :green)
    end
    puts "#{keys[i]}: #{value}"
    i += 1
  end
end

# Load initial inventory
inventory = {}
if File.exist?('inventory.txt')
  File.open('inventory.txt', 'r') do |file|
    while line = file.gets
      key, value = line.chomp.split(': ')
      inventory[key] = value
    end
  end
else
  File.open('data/base_inventory.txt', 'r') do |file|
    while line = file.gets
      key, value = line.chomp.split(': ')
      inventory[key] = value
    end
  end
end

# Main game loop
invalid_attempts = 0

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
    invalid_attempts = 0 # Reset on valid input
  elsif choice == "fight" || choice == "fight enemy"
    combat_encounter(inventory)
    invalid_attempts = 0
  elsif choice == "inventory" || choice == "check inventory" || choice == "inv"
    show_inventory(inventory)
    invalid_attempts = 0
  elsif choice == "kill yourself"
    puts""
    puts "You slit your own throat, the #{colorize('blood', :red)} pooling at your knees."
    sleep(3)
    puts""
    puts "As you fall forward, spots appear in your vision."
    sleep(3)
    puts""
    puts "As you feel the life leaving your body, a loud voice booms across the land."
    sleep(3)
    puts""
    puts "Host healthpool has depleted, running isekai.exe"
    sleep(4)
    puts""
    puts""
    puts "You wake up in a field, confused and disoriented."
    sleep(3)
    
    puts "Not knowing where you are, or how you got here, you begin exploring."
    exec("ruby #{$0}") # Restarts the script
  else
    invalid_attempts += 1
    if invalid_attempts >= 2
      puts "Invalid choice! Try 'village', 'fight', 'inventory', or if you're that lost, just type 'kill yourself' to restart."
    else
      puts "Invalid choice! Try 'village', 'fight', or 'inventory'."
    end
  end
end

