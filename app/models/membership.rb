# == Schema Information
#
# Table name: memberships
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  organization_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization
end
