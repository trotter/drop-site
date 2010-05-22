class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.text   :session
      t.string :subdomain
      t.string :last_hash

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
