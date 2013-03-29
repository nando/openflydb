#encoding: utf-8
require 'digest/sha2'
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

  belongs_to :competition
  before_create :defaults
  validates_uniqueness_of :fsdb_id, :scope => :competition_id
  validates_presence_of :competition

  before_create :set_fsdb_id
  before_save :crypt_password

  attr_accessor :new_password

  def set_fsdb_id
    self.fsdb_id ||= previous_fsdb_id || new_fsdb_id
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

  def crypt_password
    self.password = Digest::SHA512.hexdigest(new_password) if new_password.present?
  end

  def self.authenticate(email, password)
    where(:email => email, :password => Digest::SHA512.hexdigest(password)).first
  end

  private

  def previous_fsdb_id
    (Pilot.where('email like ?', "%#{self.email.strip}%").first ||
     Pilot.where('phone like ?', "%#{self.phone.strip}%").first ||
     Pilot.where('surname like ?', "%#{self.surname.strip}%").first).fsdb_id rescue nil
  end
  
  def new_fsdb_id
    (Pilot.maximum(:fsdb_id) || 0) + 1
  end

end
