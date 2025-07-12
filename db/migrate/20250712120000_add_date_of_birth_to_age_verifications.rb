class AddDateOfBirthToAgeVerifications < ActiveRecord::Migration[7.0]
  def change
    add_column :age_verifications, :date_of_birth, :date
  end
end
