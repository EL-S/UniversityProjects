require './input_functions'

# write code that reads in a user's name from the terminal.  If the name matches
# your name or your tutor's name, then print out "<Name> is an awesome name!"
# Otherwise call a function called print_silly_name(name) - which you must write -
# that prints out "<Name> is a " then print 'silly' (60 times) on one long line
# then print ' name.' 


def print_silly_name name
    tutors_name = 'arafat'  # Arafat Hossain
    my_name = 'jordan'

    if name == tutors_name or name == my_name
        puts "#{name.capitalize} is an awesome name!"
    else
        print "#{name.capitalize} is a "
        i = 0
        while i < 60
            print "silly "
            i += 1
        end
        print 'name!'
    end
end


def main
    name = read_string('Enter your name: ').downcase
    print_silly_name name
end


main
