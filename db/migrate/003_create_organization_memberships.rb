class CreateOrganizationMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :organization_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.integer :role, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.datetime :joined_at
      t.text :join_reason
      
      t.timestamps
    end
    
    add_index :organization_memberships, [:user_id, :organization_id], unique: true
    add_index :organization_memberships, :role
    add_index :organization_memberships, :status
  end
end
