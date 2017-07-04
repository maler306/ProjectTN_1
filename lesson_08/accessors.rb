module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*args)
      args.each do |arg|
        var_name = "@#{arg}".to_sym
        define_method(arg) { instance_variable_get(var_name) }

        define_method("#{arg}=".to_sym) do |value|
          instance_variable_set(var_name, value)

          @history ||= {}
          @history[var_name] ||= []
          @history[var_name] << value
        end

        define_method("#{arg}_history") { @history[var_name] }
      end
    end

    def strong_attr_acessor(name, _class_name)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |class_name|
        raise TypeError unless class_name.is_a? self.class
        instance_variable_set(var_name, class_name)
      end
    end
  end
end
