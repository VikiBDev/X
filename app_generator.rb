require 'open3'

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
end