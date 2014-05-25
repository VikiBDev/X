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

parsed_line = Hash.new

parsed_line["AND"] = Hash.new
parsed_line["generate"] = Array.new

current_keyword = ""
gem_count = -1
last_gem = ""

line.each do |word|
	if(keywords.include?(word))
		current_keyword = word
		if(current_keyword == "AND")
			gem_count += 1
		end
	elsif word == "including"
		current_keyword = "AND"
		gem_count += 1
	else
		if current_keyword == "AND"
			parsed_line["AND"][word] = Array.new
			last_gem = word
		elsif(current_keyword == "with")
			parsed_line["AND"][last_gem].push(word)
		else
			parsed_line[current_keyword].push(word)
		end
	end
end

puts parsed_line