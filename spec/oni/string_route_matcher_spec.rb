require "spec_helper"

module Oni
  describe StringRouteMatcher do
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
      subject {StringRouteMatcher.new(request)}

      before do
        Routes.route "/route", nil
        Routes.route "/route/bleh", controller
        request.stub!(:path).and_return("/route/bleh")
      end

      it "matches simple routes" do
        subject.match?.should == "controller response"
      end

      it "passes the request on to the controller" do
        controller.should_receive(:process).with(request)
        subject.match?
      end

      it "returns the response from the controller" do
        subject.match?.should == "controller response"
      end
    end

    context "different routes" do
      subject {StringRouteMatcher.new(request)}

      it "doesn't match routes that are different" do
        request.stub!(:path).and_return("/")
        subject.match?.should == false
      end
    end

    context "routes with parameters" do
      subject {StringRouteMatcher.new(request)}
      before { Routes.route "/:param1/ignore/:param2/another", controller }

      it "matches routes with parameters" do
        request.stub!(:path).and_return("/value1/ignore/value2/another")
        subject.match?.should == "controller response"
      end

      it "adds the matched parameters to the request" do
        request.stub!(:path).and_return("/value1/ignore/value2/another")
        params.should_receive(:[]=).with(:param1, "value1")
        params.should_receive(:[]=).with(:param2, "value2")
        subject.match?
      end
    end
  end
end
