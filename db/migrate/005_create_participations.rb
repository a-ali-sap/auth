class CreateParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :participation_space, null: false, foreign_key: true
      t.integer :status, default: 0
      t.datetime :joined_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :completed_at
      t.text :notes
      
      t.timestamps
    end
    
    add_index :participations, [:user_id, :participation_space_id], unique: true
    add_index :participations, :status
  end
end
