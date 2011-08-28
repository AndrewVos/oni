require "spec_helper"

module Oni
  describe StringRouteProcessor do
    before do
      Routes.reset_routes!
    end

    let :request do
      request = mock(:request)
      request.stub!(:path)
      request.stub!(:params).and_return(params)
      request
    end

    let :controller do
      controller = mock(:controller)
      controller.should_receive(:new).and_return(controller)
      controller.stub!(:process).and_return("controller response")
      controller
    end

    let :params do
      params = mock(:params)
      params.stub!(:[]=)
      params
    end

    context "simple routes" do
      subject {StringRouteProcessor.new(request)}

      before do
        Routes.route "/route", nil
        Routes.route "/route/bleh", controller
        request.stub!(:path).and_return("/route/bleh")
      end

      it "processes simple routes" do
        subject.process?.should == "controller response"
      end

      it "passes the request on to the controller" do
        controller.should_receive(:process).with(request)
        subject.process?
      end

      it "returns the response from the controller" do
        subject.process?.should == "controller response"
      end
    end

    context "different routes" do
      subject {StringRouteProcessor.new(request)}

      it "doesn't process routes that are different" do
        request.stub!(:path).and_return("/")
        subject.process?.should == false
      end
    end

    context "routes with parameters" do
      subject {StringRouteProcessor.new(request)}
      before { Routes.route "/:param1/ignore/:param2/another", controller }

      it "processes routes with parameters" do
        request.stub!(:path).and_return("/value1/ignore/value2/another")
        subject.process?.should == "controller response"
      end

      it "adds the processed parameters to the request" do
        request.stub!(:path).and_return("/value1/ignore/value2/another")
        params.should_receive(:[]=).with(:param1, "value1")
        params.should_receive(:[]=).with(:param2, "value2")
        subject.process?
      end
    end
  end
end
