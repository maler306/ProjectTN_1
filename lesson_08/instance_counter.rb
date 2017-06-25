module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      @instances
    end

    private

    def instance_counter
      @instances ||= 0
      @instances += 1
    end
  end

  module InstanceMethods
    def register_instance
      self.class.send :instance_counter
    end
  end
end
