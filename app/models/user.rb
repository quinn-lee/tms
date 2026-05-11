class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :orders, :class_name => 'TransportOrder', :dependent => :destroy, :foreign_key => :user_id

  attr_accessor :password, :password_confirmation

  validates_presence_of :nickname, message: "Can't be blank"
  validates :nickname, uniqueness: true

  validates_presence_of :password, message: "Can't be blank", 
    if: :need_validate_password
  validates_presence_of :password_confirmation, message: "Can't be blank", 
    if: :need_validate_password
  validates_confirmation_of :password, message: "Password and Re-entered Password do not match.",
    if: :need_validate_password
  validates_length_of :password, message: "Must more than 6", minimum: 6,
    if: :need_validate_password

  validates_presence_of :customer_code,:customer_name,:customer_type, message: "Can't be blank", 
    if: :is_customer?

  validates_inclusion_of :staff_grade, :in => %w[driver dispatcher appeal_handler customer administrator]
  validates_inclusion_of :status, :in => %w[out_of_service in_service on_vacation resigned]
  before_validation :setup, :on => :create

  private
  def need_validate_password
    self.new_record? ||
      (!self.password.nil? or !self.password_confirmation.nil?)
  end

  def is_customer?
    staff_grade == "customer"
  end

  def is_staff?
    staff_grade != "customer" && staff_grade != "driver"
  end

  def is_driver?
    staff_grade == "driver"
  end

  def setup
    self.status = 'in_service' if self.status.blank?
  end
end
