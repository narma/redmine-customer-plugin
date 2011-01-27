class Client < ActiveRecord::Base

  has_many :issues

  def to_s
    "#{name}"
  end

end

