  homepage 'https://github.com/plataformatec/devise'
  category 'authentication'
  version '3.2.4'

  def install
	
	system "bundle install"
	
    system "rails generate devise:install"
	
	system "rails generate devise User" if generate_models?
	
	system "rake db:migrate"
	
	system "rails generate devise:views User" if generate_views?
  end