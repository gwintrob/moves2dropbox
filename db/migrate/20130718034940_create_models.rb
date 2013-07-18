class CreateModels < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :moves_id

      t.timestamps
    end

    create_table :identities do |t|
      t.belongs_to :user
      t.string :provider
      t.string :secret
      t.string :token
      t.string :uid

      t.timestamps
    end
  end
end
