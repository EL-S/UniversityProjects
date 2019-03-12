require 'date'

INCHES = 0.393701  # This is a global constant

# Insert the missing code here into the statements below:
# gets
# gets.chomp
# Date.today.year
# year_born.to_i
# gets.to_f

def main
    puts 'What is your name?'
    puts 'Please enter your name: '
	name = gets
	puts 'Your name is ' + name + '!'
	puts 'What is your family name?'
	family_name = gets.chomp
	puts 'Your family name is: ' + family_name + '!'
	puts 'What year were you born?'
	year_born = gets.to_i
    # Calculate the users age
    current_year = Date.today.year
	age = (current_year - year_born)
	puts 'So you turn ' + age.to_s + ' years old this year'
    puts 'Enter your height in metres (i.e as a float): '
	value =  gets.to_f
	value = value * INCHES * 100
	puts 'Your height in inches is: '
	puts value.to_s
	puts 'Finished'
end

main  # call the main procedure
