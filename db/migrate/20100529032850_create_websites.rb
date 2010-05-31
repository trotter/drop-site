class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.belongs_to :user
      t.belongs_to :path
      t.string :subdomain
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :websites
  end
end
