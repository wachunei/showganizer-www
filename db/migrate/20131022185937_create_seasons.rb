class CreateSeasons < ActiveRecord::Migration
  def change

    create_table :seasons do |t|
      t.text :description
      t.date :date
      t.integer :number
      t.references :serial, index: true

      t.timestamps
    end
  end
end
