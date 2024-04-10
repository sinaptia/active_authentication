class ActiveAuthentication::ViewsGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../", __dir__)

  desc "Generates active_authentication's views."

  class_option :views, aliases: "-v", type: :array, desc: "Views to generate (available: confirmations, mailer, passwords, registrations, sessions, shared, unlocks)"

  def copy_views
    if options[:views]
      options[:views].each do |view|
        directory "app/views/active_authentication/#{view}"
      end
    else
      directory "app/views/active_authentication"
    end
  end
end
