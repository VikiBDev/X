if ARGV.length > 1
	puts "Argument count > 1"
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

parsed_line = Hash.new
keywords.each do |key|
	parsed_line[key] = Array.new
end

current_keyword = ""
last_gem = ""
with_array_length = -1

line.each do |word|
	if(keywords.include?(word))
		current_keyword = word
		if (current_keyword == "with")
			with_array_length+=1
			parsed_line[current_keyword][with_array_length] = Array.new
		end
	elsif word == "including"
		current_keyword = "AND"
	else
		if current_keyword != "with"
			parsed_line[current_keyword].push(word)
		else
			parsed_line[current_keyword][with_array_length].push(word)
		end
	end
end

puts parsed_line