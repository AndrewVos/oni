require "spec_helper"

module Oni
  class SimpleController; end
  class ParameterController; end

  describe Routes do
    def mock_request path
      request = mock(:request)
      request.stub!(:path).and_return(path)
      params = mock(:params).as_null_object
      request.stub!(:params).and_return(params)
      request
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

    it "returns nil of the route doesn't get matched" do
      Oni::Routes.match(mock_request("why hello there")).should == nil
    end

    it "matches simple routes do" do
      Oni::Routes.route "/", SimpleController
      SimpleController.stub!(:new).and_return "simple controller"
      Oni::Routes.match(mock_request("/")).should == "simple controller"
    end

    it "matches routes with parameters" do
      Oni::Routes.route "/:parameter1/:parameter2", ParameterController
      ParameterController.stub!(:new).and_return "parameter controller"
      Oni::Routes.match(mock_request("/value1/value2")).should == "parameter controller"
    end

    it "adds the request parameters to the request" do
      Oni::Routes.route "/:parameter1/:parameter2", ParameterController
      request = mock_request("/value1/value2")
      params = mock(:params)
      request.stub!(:params).and_return(params)
      params.should_receive(:[]=).with(:parameter1, "value1")
      params.should_receive(:[]=).with(:parameter2, "value2")
      Oni::Routes.match(request)
    end
  end
end
