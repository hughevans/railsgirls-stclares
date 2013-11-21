class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.decimal :lat, :precision => 9, :scale => 6
      t.decimal :lon, :precision => 9, :scale => 6

      t.timestamps
    end
  end
end
