module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(validation_name, validation_type, *options)
      @validations ||= []
      # rubocop :enable Metrics/LineLength'
      @validations << { validation_name: validation_name, validation_type: validation_type, options: options }
      # rubocop :enable Metrics/LineLength

    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue
      false
    end

    protected

    def validate!
      self.class.validations.each do |validation|
        value = instance_variable_get("@#{validation[:name]}")
        send validation[:validate_method], validation[:name], value, validation[:options]
      end
      true
    end

    def presence(name, value, *_args)
      raise "#{self.class} #{name.capitalize} не может быть пустым." if value.to_s.empty?
    end

    def format(name, value, regexp)
      raise "Недопустимый формат для #{name}." if value !~ regexp
    end

    def type(_name, _value, klass)
      raise "Тип объекта не соответствует #{klass}." unless is_a?(klass)
    end

    def uniqueness(name, value, *_option)
      ObjectSpace.each_object(self.class) { |obj| raise "#{value} существует" if obj.send(name) == value && obj != self }
    end

    def exists(_name, value, *_option)
      raise 'Станция не существует' unless Station.all.include?(value)
    end
  end
end
