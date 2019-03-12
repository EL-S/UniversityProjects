require 'date'
require './input_functions'


INCHES = 0.393701


def main
	name = read_string('Please enter your name: ')
	puts 'Your name is ' + name + '!'
	family_name = read_string('What is your family name?')
	puts 'Your family name is: ' + family_name + '!'
	year_born = read_integer('What year were you born?')
    current_year = Date.today.year
	age = (current_year - year_born)
	puts 'So you turn ' + age.to_s + ' years old this year'
	value =  read_float('Enter your height in metres (i.e as a float): ')
	value = value * INCHES * 100
	puts 'Your height in inches is: '
	puts value.to_s
	if read_boolean('Do you want to continue?')
		puts 'Ok, lets continue'
	else
		puts 'Ok, goodbye'
	end
end


main
