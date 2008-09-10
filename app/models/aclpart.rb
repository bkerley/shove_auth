class Aclpart < ActiveRecord::Base
  validates_presence_of :title
  validates_numericality_of :order
  validates_each :body do |record, attr, value|
    record.errors.add attr, 'syntax error in body' unless CACKLE.try_parse(value)
  end
  
  def self.concatenated
    self.find(:all, :order=>"order asc, id asc").map(&:body).join("\n")
  end
  
  def syntax_check
    CACKLE.try_parse(self.body)
  end
end
