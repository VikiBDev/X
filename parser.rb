def parseLine(line,keywords)

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

	parsed_line
	
end