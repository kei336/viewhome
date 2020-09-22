class AddIndexToLikes < ActiveRecord::Migration[6.0]
  def change
    add_index :likes, :user_id
    add_index :likes, :post_id
    add_index :likes, [:user_id, :post_id], unique: true
  end
end
