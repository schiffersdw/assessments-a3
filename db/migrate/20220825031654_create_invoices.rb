class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :uuid, :null => false, :length => 30, :unique => true
      t.boolean :active, :default =>  true, :null => false
      t.decimal :amount, precision: 10, scale: 2, :null => false
      t.string :currency, :length => 3, :null => false
      t.date :emitted_at, :null => false
      t.date :expires_at, :null => false
      t.date :signed_at, :null => false
      t.text :cfdi_digital_stamp, :null => false
      t.bigint :user_id, :null =>false
      t.timestamps
    end
    add_foreign_key :invoices, :users, name: "user_id_on_invoices"
  end
end

