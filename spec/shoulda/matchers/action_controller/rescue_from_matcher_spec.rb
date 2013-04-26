require 'spec_helper'

describe Shoulda::Matchers::ActionController::RescueFromMatcher do
  context 'a controller that rescues from RuntimeError' do
    it "asserts controller is setup with rescue_from" do
      controller_with_rescue_from.should rescue_from RuntimeError
    end

    it "asserts controller is not setup with rescue_from" do
      define_controller("RandomController") {}.should_not rescue_from RuntimeError
    end

    it "asserts rescue_from was set up with method" do
      controller_with_rescue_from_and_method.should rescue_from(RuntimeError).with(:error_method)
    end
  end
end

def controller_with_rescue_from
  define_controller "RescueRuntimeError" do
    rescue_from(RuntimeError) {}
  end
end

def controller_with_rescue_from_and_method
  define_controller "RescueRuntimeErrorWithMethod" do
    rescue_from RuntimeError, with: :error_method

    def error_method
      true
    end
  end
end
