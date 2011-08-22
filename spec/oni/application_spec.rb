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
      it "passes a request on to the process method" do
        env = {"PATH_INFO" => "/"}
        request = mock(:request)
        Rack::Request.should_receive(:new).with(env).and_return(request)
        application.should_receive(:process).with(request)
        application.call(env)
      end

      it "returns the response of the process method" do
        application.stub!(:process).and_return "process result"
        application.call({}).should == "process result"
      end
    end

    describe ".process" do
      context "matches a controller" do
        it "forwards a request on to the first matched controller" do
          request = mock(:request)
          Rack::Request.stub!(:new).and_return(request)
          controller = mock(:controller)
          Routes.stub!(:match).and_return(controller)
          controller.should_receive(:process).with(request)
          application.process(request)
        end

        it "returns the response of the controller" do
          controller = mock(:controller)
          controller.stub!(:process).and_return("controller response")
          Routes.stub!(:match).and_return(controller)
          application.process("hello").should == "controller response"
        end
      end

      context "doesn't match a controller" do
        it "404s if there is no matching controller" do
          request = mock(:request)
          application.process(request).status.should == 404
        end
      end
    end
  end
end
