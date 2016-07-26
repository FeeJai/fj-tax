class CreateIncomes < ActiveRecord::Migration[5.0]
  def change
    create_table :incomes do |t|
      t.references :tax_return, foreign_key: true
      t.string :employer_fed
      t.decimal :wages, precision: 9, scale: 2
      t.decimal :fed_tax_withheld, precision: 9, scale: 2
      t.decimal :state_tax_witheld, precision: 9, scale: 2

      t.timestamps
    end
  end
end
