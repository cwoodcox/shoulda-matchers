require 'spec_helper'

describe Shoulda::Matchers::ActionController::RescueFromMatcher do
  context 'a controller that rescues from RuntimeError' do
    it "asserts controller is setup with rescue_from" do
      controller_with_rescue_from.should rescue_from RuntimeError
    end

    context 'with a handler method' do
      it "asserts rescue_from was set up with handler method" do
        controller_with_rescue_from_and_method.should rescue_from(RuntimeError).with(:error_method)
      end

      it "asserts rescue_from was not set up with incorrect handler method" do
        controller_with_rescue_from_and_method.should_not rescue_from(RuntimeError).with(:other_method)
      end

      it "asserts the controller responds to the handler method" do
        matcher = rescue_from(RuntimeError).with(:error_method)
        matcher.matches?(controller_with_rescue_from_and_invalid_method).should be_false
        matcher.failure_message_for_should.should =~ /does not respond to/
      end
    end
  end

  context 'a controller that does not rescue from RuntimeError' do
    it "asserts controller is not setup with rescue_from" do
      matcher = rescue_from RuntimeError
      define_controller("RandomController").should_not matcher
      matcher.failure_message_for_should_not.should =~ /Did not expect \w+ to rescue from/
    end
  end
end

def controller_with_rescue_from
  define_controller "RescueRuntimeError" do
    rescue_from(RuntimeError) {}
  end
end

def controller_with_rescue_from_and_invalid_method
  define_controller "RescueRuntimeErrorWithMethod" do
    rescue_from RuntimeError, with: :error_method
  end
end

def controller_with_rescue_from_and_method
  controller = controller_with_rescue_from_and_invalid_method
  class << controller
    def error_method
      true
    end
  end
  controller
end
