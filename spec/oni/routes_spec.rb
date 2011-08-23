require "spec_helper"

module Oni
  class TestController; end

  describe Routes do
    subject { Oni::Routes }

    before do
      StringRouteMatcher.stub!(:new).and_return(string_route_matcher)
    end

    let :string_route_matcher do
      string_route_matcher = stub(:string_route_matcher)
      string_route_matcher.stub!(:match?).and_return(false)
      string_route_matcher
    end

    it "stores a list of routes" do
      subject.route :hello, "hello route!"
      subject.route :goodbye, "goodbye route!"
      subject.routes.should == {:hello => "hello route!", :goodbye => "goodbye route!"}
    end

    it "resets routes" do
      subject.route :hello, "the route"
      subject.reset_routes!
      subject.routes.should == {}
    end

    describe ".process" do
      before do
        TestController.stub!(:new).and_return(controller)
      end

      let :request do
        request = mock(:request)
        request.stub!(:path)
        params = mock(:params).as_null_object
        request.stub!(:params).and_return(params)
        request
      end

      let :controller do
        controller = mock(:controller)
        controller.stub!(:process)
        controller
      end

      it "creates a route matcher" do
        subject.route "/route1", TestController
        StringRouteMatcher.should_receive(:new).with("/route1", request)
        subject.process(request)
      end

      it "passes each path with the request to the route matcher" do
        subject.route "/hello", TestController
        subject.route "/goodbye", TestController
        StringRouteMatcher.should_receive(:new).with("/hello", request)
        StringRouteMatcher.should_receive(:new).with("/goodbye", request)
        subject.process(request)
      end

      context "route that doesn't match" do
        it "404s if the route doesn't get matched" do
          subject.process(request).status.should == 404
        end
      end

      context "matching route" do
        before do
          string_route_matcher.should_receive(:match?).and_return(true)
        end

        it "passes the request on to the controller" do
          controller.should_receive(:process).with(request)
          subject.process(request)
        end

        it "returns the response from the controller" do
          controller.stub!(:process).and_return("controller response")
          subject.process(request).should == "controller response"
        end
      end
    end
  end
end
