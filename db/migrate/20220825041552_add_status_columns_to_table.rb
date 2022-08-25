class AddStatusColumnsToTable < ActiveRecord::Migration[6.1]
  def up
    add_column('emitters', 'active', :boolean, :null => false, :default => true)
    add_column('receivers', 'active', :boolean, :null => false, :default => true)
  end

  def down
    remove_column('emitters', 'active') 
    remove_column('receivers', 'active') 
  end
end
