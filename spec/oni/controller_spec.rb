require "spec_helper"

module Oni
  describe Controller do
    subject { Controller.new }

    let :request do
      request = mock(:request)
      request.stub!(:params)
      request.stub!(:request_method).and_return("GET")
      request
    end

    describe ".process" do
      [:get, :put, :post, :delete, :head, :options, :patch].each do |request_method|
        it "processes '#{request_method}' requests" do
          request.stub!(:request_method).and_return(request_method.to_s.upcase)
          subject.should_receive(request_method)
          subject.process(request)
        end
      end

      it "wraps the response from the request method" do
        subject.should_receive(:get).and_return "some funky html and stuff"
        response = mock(:response)
        Rack::Response.should_receive(:new).with(["some funky html and stuff"]).and_return(response)
        subject.process(request).should == response
      end

      it "exposes the request parameters" do
        params = {:parameter => "value"}
        request.stub!(:params).and_return(params)
        subject.stub!(:get)
        subject.process(request)
        subject.params.should == request.params
      end
    end
  end
end