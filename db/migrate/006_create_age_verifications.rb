class CreateAgeVerifications < ActiveRecord::Migration[7.0]
  def change
    create_table :age_verifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :verification_method, null: false
      t.integer :verification_status, null: false, default: 0
      t.string :document
      t.datetime :verified_at
      t.references :verified_by, foreign_key: { to_table: :users }
      t.text :verification_notes
      
      t.timestamps
    end
    
    add_index :age_verifications, :verification_status
    add_index :age_verifications, :verification_method
  end
end
