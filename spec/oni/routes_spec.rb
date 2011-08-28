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
      [StringRouteProcessor, StaticFileRouteProcessor].each do |route_processor_class|
        before do
          route_processor_class.stub!(:new).and_return(route_processor)
        end

        let :request do
          request = mock(:request)
          request.stub!(:path)
          params = mock(:params).as_null_object
          request.stub!(:params).and_return(params)
          request
        end

        let :route_processor do
          route_processor = stub(:route_processor)
          route_processor.stub!(:process?).and_return(false)
          route_processor
        end

        it "creates a route processor with the request" do
          route_processor_class.should_receive(:new).with(request)
          subject.process(request)
        end

        context "route that doesn't get processed" do
          it "returns a 404" do
            subject.process(request).status.should == 404
          end
        end

        context "route that gets processed" do
          it "returns the response" do
            route_processor.should_receive(:process?).and_return("response")
            subject.process(request).should == "response"
          end
        end
      end
    end
  end
end
