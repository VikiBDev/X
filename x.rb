require('./parser.rb')

if ARGV.length > 1
	puts "Argument count > 1"
	exit
end

if ARGV.length == 0
	puts "Missing recipe file"
	exit
end

case ARGV[0]
when '-h' || '--help'
	puts "Usage ./x.rb recipe_file.rb"
	exit
when '-v' || '--version'
	puts "x version 0.1"
	exit
else
	file_path = Dir.pwd+"/"+ARGV[0]
end

if(!File.file?(file_path))
	puts file_path+" doesn't exist"
	exit
end

content = []
File.open(file_path).each do |line|
	content << line
end

if (content.length > 1)
	puts "Only 1 line required"
	exit
end

keywords = ["generate","AND","with"]

line = content[0].split(" ")

parsed_line = parseLine(line,keywords)

puts parsed_line