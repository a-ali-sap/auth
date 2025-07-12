class CreateParticipationSpaces < ActiveRecord::Migration[7.0]
  def change
    create_table :participation_spaces do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :organization, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.integer :participation_type, default: 0
      t.integer :status, default: 0
      t.integer :max_participants, null: false
      t.integer :current_participants, default: 0
      t.string :allowed_age_groups, array: true, default: []
      t.json :content_filters
      t.datetime :start_date
      t.datetime :end_date
      
      t.timestamps
    end
    
    # add_index :participation_spaces, :organization_id
    # add_index :participation_spaces, :creator_id
    add_index :participation_spaces, :status
    add_index :participation_spaces, :participation_type
  end
end
