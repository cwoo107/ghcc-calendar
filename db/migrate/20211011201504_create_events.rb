class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.json :event_details

      t.timestamps
    end
  end
end
