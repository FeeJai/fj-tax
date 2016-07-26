# == Schema Information
#
# Table name: incomes
#
#  id                :integer          not null, primary key
#  tax_return_id     :integer
#  employer_fed      :string
#  wages             :decimal(9, 2)
#  fed_tax_withheld  :decimal(9, 2)
#  state_tax_witheld :decimal(9, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class IncomeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
