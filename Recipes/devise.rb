  homepage 'https://github.com/plataformatec/devise'
  category 'authentication'
  version '3.2.4'

  def install
	
	system "bundle install"
	
    system "rails generate devise:install"
	
	system "rails generate devise #{model}" if generate_models?
	
	system "rake db:migrate"
	
	system "rails generate devise:views #{model}" if generate_views?
  end