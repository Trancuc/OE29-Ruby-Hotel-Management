class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # USER_PERMIT = %i(email name address age password password_confirmation gender)
  #               .freeze
  USER_PERMIT = %i(email password password_confirmation)
                  .freeze
  attr_accessor :remember_token, :activation_token

  has_many :comments, dependent: :destroy
  has_many :bills, dependent: :destroy
  has_many :bookings, through: :bills
  has_many :rates, dependent: :destroy

  enum gender: {
    male: 0,
    female: 1,
    other: 2
  }

  enum role: {
    client: 0,
    staff: 1,
    admin: 2
  }
  # validates :name, presence: true,
  #           length: {maximum: Settings.user.validate.name_max}
  # validates :age, presence: true,
  #           numericality: {only_integer: true, greater_than: Settings.inter}
  validates :email, presence: true,
            length: {maximum: Settings.user.validate.email_max},
            format: {with: URI::MailTo::EMAIL_REGEXP},
            uniqueness: {case_sensitive: true}
  validates :password, presence: true,
            length: {minimum: Settings.user.validate.pass_min},
            allow_nil: true


  before_save :downcase_email
  before_create :create_activation_digest

  scope :by_email, (lambda do |email|
    where "email LIKE ?", "%#{email}%" if email.present?
  end)

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_activation_reservation bill
    UserMailer.reservation_activation(self, bill).deliver_now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def booked? room
    bookings.map(&:room).include? room
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
