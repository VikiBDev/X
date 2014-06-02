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

	puts "Installing "+gem_name+" "+parsed_recipe["version"]+"..."
	puts "More info: "+parsed_recipe["homepage"]

	Dir.chdir app_name

	parsed_recipe["system"].each do |element|
		if element["restrictions"].nil?
			executeCommand(element["command"])
		elsif options.include? element["restrictions"]
			executeCommand(element["command"])
		end
	end

	Dir.chdir "../"

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
	Open3.popen3(command) {|stdin, stdout, stderr, wait_thr|
		
		if(wait_thr.value.exitstatus != 0)
			stderr.each do |line|
				p line
			end
			exit
		end
	}
end