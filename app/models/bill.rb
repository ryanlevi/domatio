class Bill < ActiveRecord::Base
  attr_accessible :groupid, :name, :owner, :price, :duedate

  # The following code makes validations show humanized attributes
  # (like instead of saying "price is wrong" it says "amount due is wrong")
  HUMANIZED_ATTRIBUTES = {
  :price => "Amount Due",
  :duedate => "Due Date"
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  validates :price, :presence => true,
            :numericality => {:greater_than => 0.0, :less_than => 10000, :message => "must be between $0.00 and $10,000."},
            :format => { :with => /^\d{1,4}(\.\d{0,2})?$/ }
  validates :duedate, :presence => true,
  			    :format => { :with => /\d\d\d\d-\d\d-\d\d/ }
end
