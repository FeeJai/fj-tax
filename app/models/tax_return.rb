# == Schema Information
#
# Table name: tax_returns
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  year             :integer
#  visa             :integer
#  arrival          :date
#  departure        :date
#  previous         :boolean
#  previous_visits  :jsonb
#  previous_returns :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TaxReturn < ApplicationRecord
  belongs_to :user
end
