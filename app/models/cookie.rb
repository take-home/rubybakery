class Cookie < ActiveRecord::Base
  belongs_to :storage, polymorphic: :true
  
  # sanitize data before store for enforce security
  before_save :sanitize_fillings
  
  private

  def sanitize_fillings
    self.fillings = nil if fillings.blank?
  end
end
