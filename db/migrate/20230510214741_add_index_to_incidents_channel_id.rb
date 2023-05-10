class AddIndexToIncidentsChannelId < ActiveRecord::Migration[6.1]
  def change
    add_index :incidents, :channel_id
  end
end