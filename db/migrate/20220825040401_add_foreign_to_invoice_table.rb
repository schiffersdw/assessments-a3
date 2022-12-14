class AddForeignToInvoiceTable < ActiveRecord::Migration[6.1]
  
  def up
    add_column('invoices', 'receiver_id', :bigint, :null => false)
    add_foreign_key :invoices, :receivers, name: "receive_id_on_invoices", column: :receiver_id

    add_column('invoices', 'emitter_id', :bigint, :null => false)
    add_foreign_key :invoices, :emitters, name: "emitter_id_on_invoices", column: :emitter_id

  end

  def down 
    remove_column('invoices', 'receiver_id') 
    remove_column('invoices', 'emitter_id')    
  end

end
