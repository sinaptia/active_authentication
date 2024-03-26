class Pauth::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path("templates", __dir__)

  def self.next_migration_number(dirname)
    ActiveRecord::Migration.new.next_migration_number 0
  end

  def generate_model
    invoke "active_record:model", %w[User], migration: false, skip_collision_check: true

    if behavior == :invoke
      inject_into_class "app/models/user.rb", "User", "  authenticates\n"
    end
  end

  def generate_migration
    migration_template "migration.rb", "db/migrate/create_users.rb", migration_version: migration_version, ip_column: ip_column
  end

  def add_route
    route "pauth"
  end

  def copy_initializer
    template "initializer.rb", "config/initializers/pauth.rb"
  end

  private

  def ar_config
    if ActiveRecord::Base.configurations.respond_to?(:configs_for)
      ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: "primary").configuration_hash
    else
      ActiveRecord::Base.configurations[Rails.env]
    end
  end

  def ip_column
    postgresql? ? "inet" : "string"
  end

  def migration_version
    "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
  end

  def postgresql?
    ar_config.present? && ar_config["adapter"] == "postgresql"
  end
end
