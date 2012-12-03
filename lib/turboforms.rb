module Turboforms
  module DataAttribute
    extend ActiveSupport::Concern

    included do
      alias_method_chain :form_for, :data_turboform
      alias_method_chain :form_tag, :data_turboform
    end

    def form_for_with_data_turboform(record_or_name_or_array, *args, &proc)
      options = args.extract_options!

      if options.has_key?(:turboform) && options.delete(:turboform)
        options[:html] ||= {}
        options[:html]["data-turboform"] = true
        options[:remote] = true
      end

      form_for_without_data_turboform(
        record_or_name_or_array,
        *(args << options),
        &proc
      )
    end

    def form_tag_with_data_turboform(record_or_name_or_array, *args, &proc)
      options = args.extract_options!

      if options.has_key?(:turboform) && options.delete(:turboform)
        options[:data] ||= {}
        options[:data]["turboform"] = true
        options[:remote] = true
      end

      form_tag_without_data_turboform(
        record_or_name_or_array,
        *(args << options),
        &proc
      )
    end
  end

  class Engine < ::Rails::Engine
    initializer :turboforms_data_attribute do |app|
      ActionView::Base.send :include, DataAttribute
    end
  end
end
