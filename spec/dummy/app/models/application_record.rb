# App-local base ActiveRecord class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
