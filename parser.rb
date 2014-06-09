def parseLine(line,keywords)

	parsed_line = Hash.new

	parsed_line["AND"] = Hash.new
	parsed_line["generate"] = Array.new

	current_keyword = ""
	last_gem = ""

	line.each do |word|
		if(keywords.include?(word))
			current_keyword = word
		elsif word == "including"
			current_keyword = "AND"
		else
			if current_keyword == "AND"
				parsed_line["AND"][word] = Array.new
				last_gem = word
			elsif(current_keyword == "with")
				word.split(",").each do |condition|
					parsed_line["AND"][last_gem].push(condition)
				end
			else
				parsed_line[current_keyword].push(word)
			end
		end
	end

	parsed_line

end

def parseRecipe(recipe,keywords)

	parsed_recipe = Hash.new

	parsed_recipe["system"] = Array.new

	current_keyword = ""

	# recipe["system"][0]["command"] contains the command itself
	# recipe["system"][0]["only"] contains the command restrictions, if it's empty it must always be executed

	recipe.each_with_index do |line_string,index|
		line_string.lstrip!.rstrip!
		line = line_string.split(" ")

		if(keywords.include?(line[0]))
			current_keyword = line[0]
			if(current_keyword == "system")
				if(line_string.scan(/if generate_models?/).length != 0)
					element = Hash.new
					line_string.slice!(current_keyword)
					line_string.slice!("if generate_models?")
					element["command"] = line_string
					element["only"] = "models"
					parsed_recipe[current_keyword].push(element)
				elsif (line_string.scan(/if generate_views?/).length != 0)
					element = Hash.new
					line_string.slice!(current_keyword)
					line_string.slice!("if generate_views?")
					element["command"] = line_string
					element["only"] = "views"
					parsed_recipe[current_keyword].push(element)
				else
					element = Hash.new
					line_string.slice!(current_keyword)
					element["command"] = line_string
					parsed_recipe[current_keyword].push(element)
				end
			else
				line_string.slice!(current_keyword)
				parsed_recipe[current_keyword] = line_string
			end
		elsif(!line_string.empty?)
			puts "line "+index.to_s+": Sintax error, invalid keyword "+line[0]
			exit
		end
	end

	parsed_recipe

end