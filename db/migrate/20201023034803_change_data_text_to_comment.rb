class ChangeDataTextToComment < ActiveRecord::Migration[6.0]
  def change
    change_column :comments, :text, :string
  end
end
