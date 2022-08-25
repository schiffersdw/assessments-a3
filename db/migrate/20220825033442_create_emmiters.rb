class CreateEmmiters < ActiveRecord::Migration[6.1]
  def change
    create_table :emmiters do |t|
      t.string :name, :null => false, :length => 200
      t.string :rfc, :null => false, :length => 13, index: { unique: true, name: 'unique_emmiter_rfc' }
      t.timestamps
    end
  end
end
