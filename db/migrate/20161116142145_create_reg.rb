class CreateReg < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :name_user
    end

    create_table :tweets do |t|
      t.belongs_to :twitter_user, index: true, :limit => 8
      t.string :tweet_w
      t.timestamp :created_at
    end
  end
end
