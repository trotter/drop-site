class CreatePaths < ActiveRecord::Migration
  def self.up
    create_table :paths do |t|
      t.string     :path
      t.string     :last_hash
      t.boolean    :directory
      t.belongs_to :user

      t.timestamps
    end
  end

  def self.down
    drop_table :paths
  end
end
