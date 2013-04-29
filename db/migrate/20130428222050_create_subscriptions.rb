class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :show_id
      t.integer :episode_id

      t.timestamps
    end
  end
end
