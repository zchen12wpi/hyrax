require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../support", __FILE__)

  def run_sufia_generator
    say_status("warning", "GENERATING SUFIA", :yellow)
    generate 'sufia', '-f'
    generate "browse_everything:config"
    remove_file 'spec/factories/users.rb'
  end

  def add_create_permissions
    insert_into_file 'app/models/ability.rb', after: 'custom_permissions' do
      "\n    can :create, :all if user_groups.include? 'registered'\n"
    end
  end
  
  def add_sufia_assets
    insert_into_file 'app/assets/stylesheets/application.css', after: ' *= require_self' do
      "\n *= require sufia"
    end
    insert_into_file 'app/assets/javascripts/application.js', before: '//= require_tree .' do
      "//= require sufia\n"
    end  
  end
end
