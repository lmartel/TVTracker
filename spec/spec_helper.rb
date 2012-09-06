ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'factory_girl'

# RSpec.configure do |config|
#   config.include FactoryGirl::Syntax::Methods
# end


def empty_database
  Dir[Rails.root.to_s + '/app/models/**/*.rb'].each do |file| 
    begin
      require file
    rescue
    end
  end
  ActiveRecord::Base.descendants.each do |model|
    model.destroy_all
  end
end

# models = ActiveRecord::Base.subclasses.collect { |type| type.name }.sort