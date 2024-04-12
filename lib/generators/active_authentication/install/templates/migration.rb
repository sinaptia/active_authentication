class CreateUsers < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :users do |t|
      # authenticatable
      t.string :email, null: false
      t.string :password_digest, null: false

      # confirmable
      <%= "# " unless concerns.include? "confirmable" -%>t.string :unconfirmed_email

      # lockable
      <%= "# " unless concerns.include? "lockable" -%>t.integer :failed_attempts, null: false, default: 0
      <%= "# " unless concerns.include? "lockable" -%>t.datetime :locked_at

      # trackable
      <%= "# " unless concerns.include? "trackable" -%>t.integer :sign_in_count, null: false, default: 0
      <%= "# " unless concerns.include? "trackable" -%>t.datetime :current_sign_in_at
      <%= "# " unless concerns.include? "trackable" -%>t.datetime :last_sign_in_at
      <%= "# " unless concerns.include? "trackable" -%>t.<%= ip_column %> :current_sign_in_ip
      <%= "# " unless concerns.include? "trackable" -%>t.<%= ip_column %> :last_sign_in_ip

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
