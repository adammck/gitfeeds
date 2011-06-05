class CreateRepos < ActiveRecord::Migration
  def self.up
    create_table :repos do |t|
      t.string :url, :null=>false
    end
  end

  def self.down
    drop_table :repos
  end
end
