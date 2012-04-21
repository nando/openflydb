#encoding: utf-8
class Pilot < ActiveRecord::Base
  GLIDER_TYPES = {
    0 => 'Mástil',
    1 => 'Calva',
    5 => 'Rígida'
  }
  TSHIRT_SIZES = {
    1 => 'S',
    2 => 'M',
    3 => 'L',
    4 => 'XL'
  }

  before_create :defaults
  validates_uniqueness_of :fsdb_id

  before_create :set_fsdb_id

  def set_fsdb_id
    logger.info "Pilot.maximum #{Pilot.maximum(:fsdb_id)}"
    self.fsdb_id ||= Pilot.maximum(:fsdb_id) + 1
    logger.info "fsdb_id #{self.fsdb_id)}"
  end
    

  def glider_type
    GLIDER_TYPES[glider_class]
  end

  def tshirt
    TSHIRT_SIZES[tshirt_size]
  end

  def female?
    gender && gender.upcase == 'F'
  end

  def defaults
    self.nationality = 'ESP'
    self.gender = 'M'
  end
end
