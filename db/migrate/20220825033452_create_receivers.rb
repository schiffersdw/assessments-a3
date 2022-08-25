class CreateReceivers < ActiveRecord::Migration[6.1]
  def change
    create_table :receivers do |t|
      t.string :name, :null => false, :length => 200
      t.string :rfc, :null => false, :length => 13, index: { unique: true, name: 'unique_receiver_rfc' }
      t.timestamps
    end
  end
end
