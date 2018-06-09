class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # add some methods (xxx_text, self.xxx_options)
  def self.enum(definitions)
    super

    enum_prefix = definitions.delete(:_prefix)
    enum_suffix = definitions.delete(:_suffix)

    definitions.each do |name, values|

      # xxx_text 定義
      define_method ("#{name}_text") { self.class.enum_text(name, send(name)) }

      # xxx_options 定義
      self.singleton_class.send(:define_method, "#{name}_options") { enum_options(name) }
    end
  end

  private
  def self.enum_text(name, key)
    if name.blank? || key.blank?
      nil
    else
      ApplicationController.helpers.t("enum.#{self.to_s.underscore}.#{name}.#{key}")
    end
  end

  def self.enum_options(name)
    enums = self.send(name.to_s.pluralize)
    enums.map {|key, _| [enum_text(name, key), key] }
  end
end
