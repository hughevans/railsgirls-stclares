class Activity < ActiveRecord::Base
  attr_accessible :description, :lat, :lon, :name
end
