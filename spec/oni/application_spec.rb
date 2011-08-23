require "spec_helper"

class ExampleController
end

module Oni
  describe Application do
    before do
      Oni::Routes.reset_routes!
    end

    let :application do
      Application.new
    end

    describe ".call" do
      it "passes a request on to the routes" do
        env = {"PATH_INFO" => "/"}
        request = mock(:request)
        Rack::Request.should_receive(:new).with(env).and_return(request)
        Oni::Routes.should_receive(:process).with(request)
        application.call(env)
      end

      it "returns the response of the routes" do
        Oni::Routes.stub!(:process).and_return "routes result"
        application.call({}).should == "routes result"
      end
    end
  end
end
