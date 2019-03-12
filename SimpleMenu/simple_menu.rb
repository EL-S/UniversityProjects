require './input_functions'


def maintain_albums
  puts 'You selected Enter or Update New Album'
  finished = false
  begin
    puts 'Sub Menu Maintain Albums: Enter your selection:'
    puts '1 To Enter a new Album'
    puts '2 To Update an existing Album'
    puts '3 Return to the Main Menu'
    choice = read_integer_in_range("Please enter your choice:", 1, 3)
    case choice
    when 1
      enter_album
    when 2
      update_existing_album
    when 3
      finished = true
    else
      puts 'Please select again'
    end
  end until finished
end


def enter_album
  puts 'You selected Enter a new Album'
  read_string("Press enter to continue")
end


def update_existing_album
  puts 'You selected Update an existing Album'
  read_string("Press enter to continue")
end


def play_existing_album
  puts 'You selected Play Album.'
  read_string("Press enter to continue")
end


def main
  finished = false
  begin
    puts 'Main Menu:'
    puts '1 To Enter or Update Album'
    puts '2 To Play existing Album'
    puts '3 Exit'
    choice = read_integer_in_range("Please enter your choice:", 1, 3)
    case choice
    when 1
      maintain_albums
    when 2
      play_existing_album
    when 3
      finished = true
    else
      puts 'Please select again'
    end
  end until finished
end


main
