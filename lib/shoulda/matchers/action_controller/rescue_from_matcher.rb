module Shoulda
  module Matchers
    module ActionController
      def rescue_from(exception)
        RescueFromMatcher.new exception
      end

      class RescueFromMatcher
        def initialize(exception)
          @exception = exception
        end

        def with(method)
          @method = method
          self
        end

        def matches?(controller)
          @controller = controller
          rescues_from_exception? && method_name_matches? && handler_exists?
        end

        def description
          description = "rescues from #{@exception}"
          description << " with ##{@method}"
          description
        end

        def failure_message_for_should
          "Expected #{expectation}"
        end

        def failure_message_for_should_not
          "Did not expect #{expectation}"
        end

        private
        def expectation
          expectation = "#{@controller} to rescue from #{@exception}"
          expectation << " with ##{@method}" if @method && !method_name_matches?
          unless handler_exists?
            expectation << " but #{@controller} does not respond to #{@method}"
          end
        end

        def rescues_from_exception?
          @handlers = @controller.rescue_handlers.select do |handler|
            handler.first == @exception.to_s
          end
          @handlers.any?
        end

        def method_name_matches?
          if @method
            @handlers.any? do |handler|
              handler.last == @method
            end
          else
            true
          end
        end

        def handler_exists?
          if @method
            @controller.respond_to? @method
          else
            true
          end
        end
      end
    end
  end
end
