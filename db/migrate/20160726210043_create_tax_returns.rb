class CreateTaxReturns < ActiveRecord::Migration[5.0]
  def change
    create_table :tax_returns do |t|
      t.references :user, foreign_key: true
      t.integer :year
      t.integer :visa
      t.date :arrival
      t.date :departure
      t.boolean :previous
      t.jsonb :previous_visits
      t.jsonb :previous_returns

      t.timestamps
    end
  end
end
