module Noticed
  class DeliveryMethod < ApplicationJob
    include ApiClient
    include RequiredOptions

    class_attribute :logger, default: Rails.logger

    attr_reader :config, :event, :notification
    delegate :recipient, to: :notification

    def perform(delivery_method_name, notification, overrides: {})
      @notification = notification
      @event = notification.event

      # Look up config from Notifier and merge overrides
      @config = event.delivery_methods.fetch(delivery_method_name).config.merge(overrides)

      return false if config.has_key?(:if) && !evaluate_option(:if)
      return false if config.has_key?(:unless) && evaluate_option(:unless)

      deliver
    end

    def deliver
      raise NotImplementedError, "Delivery methods must implement the `deliver` method"
    end

    def fetch_constant(name)
      option = config[name]
      option.is_a?(String) ? option.constantize : option
    end

    def evaluate_option(name)
      option = config[name]

      # Evaluate Proc within the context of the Notification
      if option&.respond_to?(:call)
        notification.instance_exec(&option)

      # Call method if symbol and matching method on Notifier
      elsif option.is_a?(Symbol) && event.respond_to?(option)
        event.send(option, self)

      # Return the value
      else
        option
      end
    end
  end
end
