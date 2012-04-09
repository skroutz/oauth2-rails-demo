# -*- encoding : utf-8 -*-
class Person
  attr_accessor :first_name, :last_name
  attr_accessor :email, :address

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) rescue NoMethodError
    end
  end
end
