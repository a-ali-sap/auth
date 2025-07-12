class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name,               null: false
      t.text :description,          null: false
      t.integer :organization_type, null: false
      t.integer :status,            default: 0
      t.boolean :is_public,         default: true
      t.string :website_url
      t.string :contact_email
      t.string :phone_number
      t.text :address
      t.references :owner, null: false, foreign_key: { to_table: :users }
      
      t.timestamps
    end
    
    add_index :organizations, :name, unique: true
    add_index :organizations, :organization_type
    add_index :organizations, :status
    add_index :organizations, :is_public
  end
end
