require "spec_helper"

module Oni
  describe StringRouteMatcher do
    subject {StringRouteMatcher.new}

    let :request do
      request = mock(:request)
      request.stub!(:path)
      request.stub!(:params).and_return(params)
      request
    end

    let :params do
      params = mock(:params)
      params.stub!(:[]=)
      params
    end

    it "matches simple routes" do
      request.stub!(:path).and_return("/")
      subject.match?("/", request).should == true
    end

    it "doesn't match routes that are different" do
      request.stub!(:path).and_return("/")
      subject.match?("/blabla", request).should == false
    end

    it "matches routes with parameters" do
      request.stub!(:path).and_return("/value1/ignore/value2/another")
      subject.match?("/:param1/ignore/:param2/another", request).should == true
    end

    it "adds the matched parameters to the request" do
      request.stub!(:path).and_return("/value1/ignore/value2/another")
      params.should_receive(:[]=).with(:param1, "value1")
      params.should_receive(:[]=).with(:param2, "value2")
      subject.match?("/:param1/ignore/:param2/another", request)
    end
  end
end
    #context "route with parameters" do
      #before do
        #subject.route "/:parameter1/:parameter2", TestController
        #request.stub!(:path).and_return("/value1/value2")
      #end

      #it "matches routes with parameters" do
        #controller.should_receive(:process).with(request)
        #subject.match(request)
      #end

    #end
