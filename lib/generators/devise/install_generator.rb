# frozen_string_literal: true

require 'rails/generators/base'
require 'securerandom'

module Devise
  module Generators
    MissingORMError = Class.new(Thor::Error)

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Devise initializer and copy locale files to your application."
      class_option :orm, required: true

      def copy_initializer
        unless options[:orm]
          raise MissingORMError, <<-ERROR.strip_heredoc
          An ORM must be set to install Devise in your application.

          Be sure to have an ORM like Active Record or Mongoid loaded in your
          app or configure your own at `config/application.rb`.

            config.generators do |g|
              g.orm :your_orm_gem
            end
          ERROR
        end

        devise_template = Rails::VERSION::MAJOR >= 7 ? "devise_turbo.rb" : "devise.rb"
        template devise_template, "config/initializers/devise.rb"
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise.en.yml"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
