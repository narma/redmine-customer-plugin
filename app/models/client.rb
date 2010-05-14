class Client < ActiveRecord::Base

  belongs_to :project
  has_many :customers, :dependent => :destroy

  # name or company is mandatory
  validates_presence_of :name

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :allow_nil => true, :allow_blank => true
  #TODO validate website address
  #TODO validate skype_name contact

end

