class CreateParentalConsents < ActiveRecord::Migration[7.0]
  def change
    create_table :parental_consents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :participation_space, null: false, foreign_key: true
      t.string :parent_name, null: false
      t.string :parent_email, null: false
      t.string :parent_phone, null: false
      t.string :relationship, null: false
      t.integer :status, default: 0
      t.integer :consent_method, default: 0
      t.string :verification_code
      t.datetime :consent_given_at
      t.datetime :approved_at
      t.datetime :expires_at
      t.text :rejection_reason
      
      t.timestamps
    end
    
    add_index :parental_consents, [:user_id, :participation_space_id]
    add_index :parental_consents, :status
    add_index :parental_consents, :expires_at
  end
end
