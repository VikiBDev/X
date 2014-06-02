require 'open3'
require './gem_handler.rb'

def generateApp(recipe)
	version = recipe["generate"][0]
	app_name = recipe["generate"][1]

	Open3.popen3("rails _#{version}_ new #{app_name}") {|stdin, stdout, stderr, wait_thr|
		
		if(wait_thr.value.exitstatus != 0)
			stderr.each do |line|
				p line
			end
			exit
		end
	}

	recipe["AND"].each do |gem_name,options|
		if(gem_name[0] =~ /^[A-Z]/) #it's a category
			gem_name = chooseGem(gem_name)
		end

		installGem(gem_name,options,app_name)
	end
end