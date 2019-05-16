
# takes a number and writes that number to a file then on each line

def write(aFile, number)
  # You might need to fix this next line:
  aFile.puts(number.to_s)
  values = 0..number
  for value in values
   aFile.puts(value)
  end
end

# Read the data from the file and print out each line
def read(aFile)
  count = aFile.gets
  if (is_numeric?(count))
    count = count.to_i + 1
    count.times do
      line = aFile.gets
      puts "Line read: " + line
    end
  else
    puts "Error: first line of file is not a number"
  end
end

# Write data to a file then read it in and print it out
def main
  aFile = File.new("mydata.txt", "w") # open for writing
  if aFile  # if nil this test will be false
    print "Enter a number: "
    number = gets.chomp.to_i
    write(aFile, number)
  else
    puts "Unable to open file to write!"
  end
  aFile.close

  aFile = File.new("mydata.txt", "r") # open for reading
  if aFile
    read(aFile)
  end
  aFile.close
end

# returns true if a string contains only digits
def is_numeric?(obj)
  if /[^0-9]/.match(obj) != nil
    return true
  end
  false
end

main
