class ActiveAuthentication::OmniauthableGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  desc "Creates the Authentication model"

  def generate_model
    invoke "active_record:model", %w[Authentication uid:string provider:string user:references auth_data:json], skip_collision_check: true

    if behavior == :invoke
      inject_into_class "app/models/authentication.rb", "Authentication", "  validates :provider, presence: true\n  validates :uid, presence: true, uniqueness: {scope: :provider}\n"
    end
  end
end
