require 'open3'

def installGem(gem_name,options,app_name)
	file_path = Dir.pwd+"/Recipes/"+gem_name+".rb"

	if(!File.file?(file_path))
		puts "Sorry, "+gem_name+" is not supported"
		exit
	end

	File.open(Dir.pwd+"/"+app_name+"/Gemfile").each do |line|
		if line.include?(gem_name)
			puts gem_name+" already installed"
			exit
		end
	end

	content = []

	File.open(file_path).each do |line|
		content << line
	end

	keywords = ["system","homepage","category","version","def","end"]

	parsed_recipe = parseRecipe(content,keywords)

	# adding gem to gemfile
	File.open(Dir.pwd+"/"+app_name+"/Gemfile","a") do |file|
		file.puts "#gem added by X"
		string = "gem \"#{gem_name}\""
		unless parsed_recipe["version"].nil?
			string += ", #{parsed_recipe["version"]}"
		end
		file.puts string
	end

	puts "Installing "+gem_name+" "+parsed_recipe["version"]+"..."
	puts "More info: "+parsed_recipe["homepage"]

	Dir.chdir app_name do

		parsed_recipe["system"].each do |element|
			if element["only"].nil?
				executeCommand(element["command"])
			elsif options.include? element["only"]
				executeCommand(element["command"])
			end
		end

	end

end

# suggested gem for each category, hard coded seems the way to go
def chooseGem(category)
	case category
	when "Authentication"
		 "devise"
	when "Testing"
		"cucumber"
	when "Layout"
		 "bootstrap"
	else
		 puts "Category "+category+" doesn't exist"
		 exit
	end
end

def executeCommand(command)
	p command.rstrip.lstrip.gsub(/"/,'')
	Open3.popen3(command.rstrip.lstrip.gsub(/\"/,'')) {|stdin, stdout, stderr, wait_thr|
		
		if(wait_thr.value.exitstatus != 0)
			stderr.each do |line|
				p line
			end
			exit
		end
	}

end