class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      # creates created_at and updated_at
      t.timestamps
    end
  end
end
