require "spec_helper"

module Oni
  describe StringRouteMatcher do
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

    context "simple routes" do
      subject {StringRouteMatcher.new("/", request)}

      it "matches simple routes" do
        request.stub!(:path).and_return("/")
        subject.match?.should == true
      end
    end

    context "different routes" do
      subject {StringRouteMatcher.new("/blabla", request)}

      it "doesn't match routes that are different" do
        request.stub!(:path).and_return("/")
        subject.match?.should == false
      end
    end

    context "routes with parameters" do
      subject {StringRouteMatcher.new("/:param1/ignore/:param2/another", request)}

      it "matches routes with parameters" do
        request.stub!(:path).and_return("/value1/ignore/value2/another")
        subject.match?.should == true
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
