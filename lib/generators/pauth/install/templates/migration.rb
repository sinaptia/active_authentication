class CreateUsers < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :users do |t|
      # authenticatable
      t.string :email, null: false
      t.string :password_digest, null: false

      # confirmable
      t.string :unconfirmed_email

      # lockable
      t.integer :failed_attempts, null: false, default: 0
      t.datetime :locked_at

      # trackable
      t.integer :sign_in_count, null: false, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.<%= ip_column %> :current_sign_in_ip
      t.<%= ip_column %> :last_sign_in_ip

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
