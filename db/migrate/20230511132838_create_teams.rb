class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :team_id
      t.string :token

      t.timestamps
    end
    add_index :teams, :team_id
  end
end
