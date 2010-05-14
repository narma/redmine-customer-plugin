class Customer < ActiveRecord::Base

  belongs_to :clients

  # first_name or last_name is mandatory
  validates_presence_of :first_name, :if => :last_name_unsetted
  validates_presence_of :last_name, :if => :first_name_unsetted

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :allow_nil => true, :allow_blank => true
  #TODO validate website address
  #TODO validate skype_name contact

   def pretty_name
     result = []
     [self.first_name, self.last_name].each do |field|
       result << field unless field.blank?
     end

     return result.join(", ")
   end

  private

  def first_name_unsetted
    self.first_name.blank?
  end

  def last_name_unsetted
    self.last_name.blank?
  end

end

