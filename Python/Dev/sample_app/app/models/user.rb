class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
after_create :assign_default_role

validates_presence_of :avatar, :name
has_attached_file :avatar, styles: {
thumb: '70x70#',
medium: '95x'
}

private
def assign_default_role
    add_role(:enthusiast) if self.roles.blank?
end

end
