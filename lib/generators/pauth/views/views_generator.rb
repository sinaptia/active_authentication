class Pauth::ViewsGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../", __dir__)

  desc "Generates pauth's views."

  class_option :views, aliases: "-v", type: :array, desc: "Views to generate (available: confirmations, passwords, registrations, sessions)"

  def copy_views
    if options[:views]
      options[:views].each do |view|
        directory "app/views/pauth/#{view}"
      end
    else
      directory "app/views/pauth"
    end
  end
end
