require "spec_helper"

module Oni
  class TestController; end

  describe Routes do
    subject { Oni::Routes }

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
      [StringRouteMatcher, StaticFileRouteMatcher].each do |route_matcher_class|
        before do
          route_matcher_class.stub!(:new).and_return(route_matcher)
        end

        let :request do
          request = mock(:request)
          request.stub!(:path)
          params = mock(:params).as_null_object
          request.stub!(:params).and_return(params)
          request
        end

        let :route_matcher do
          route_matcher = stub(:route_matcher)
          route_matcher.stub!(:match?).and_return(false)
          route_matcher
        end

        it "creates a route matcher with the request" do
          route_matcher_class.should_receive(:new).with(request)
          subject.process(request)
        end

        context "route that doesn't match" do
          it "returns a 404" do
            subject.process(request).status.should == 404
          end
        end

        context "route that matches" do
          it "returns the response" do
            route_matcher.should_receive(:match?).and_return("response")
            subject.process(request).should == "response"
          end
        end
      end
    end
  end
end
