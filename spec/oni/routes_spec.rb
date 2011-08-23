require "spec_helper"

module Oni
  class TestController; end

  describe Routes do
    subject { Oni::Routes }

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

    it "stores a list of routes" do
      Oni::Routes.route :hello, "hello route!"
      Oni::Routes.route :goodbye, "goodbye route!"
      Oni::Routes.routes.should == {:hello => "hello route!", :goodbye => "goodbye route!"}
    end

    it "resets routes" do
      Oni::Routes.route :hello, "the route"
      Oni::Routes.reset_routes!
      Oni::Routes.routes.should == {}
    end

    it "404s if the route doesn't get matched" do
      subject.match(request).status.should == 404
    end

    before do
      StringRouteMatcher.stub!(:new).and_return(string_route_matcher)
    end

    let :string_route_matcher do
      string_route_matcher = stub(:string_route_matcher)
      string_route_matcher.stub!(:match?).and_return(false)
      string_route_matcher
    end

    describe ".match" do
      before do
        request.stub!(:path).and_return("/")
      end

      it "creates a route matcher" do
        subject.route "/route1", TestController
        StringRouteMatcher.should_receive(:new).with("/route1", request)
        subject.match(request)
      end

      it "passes each path with the request to the route matcher" do
        subject.route "/hello", TestController
        subject.route "/goodbye", TestController
        StringRouteMatcher.should_receive(:new).with("/hello", request)
        StringRouteMatcher.should_receive(:new).with("/goodbye", request)
        subject.match(request)
      end

      it "passes the request on to the controller" do
        string_route_matcher.should_receive(:match?).and_return(true)
        controller.should_receive(:process).with(request)
        subject.match(request)
      end

      it "returns the response from the controller" do
        string_route_matcher.should_receive(:match?).and_return(true)
        controller.stub!(:process).and_return("controller response")
        subject.match(request).should == "controller response"
      end
    end
  end
end
