class AddStatusColumnsToTable < ActiveRecord::Migration[6.1]
  def up
    add_column('emmiters', 'active', :boolean, :null => false, :default => true)
    add_column('receivers', 'active', :boolean, :null => false, :default => true)
  end

  def down
    remove_column('emmiters', 'active') 
    remove_column('receivers', 'active') 
  end
end
