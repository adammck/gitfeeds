class AddPulledAtToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :pulled_at, :datetime
  end
end
