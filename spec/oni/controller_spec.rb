require "spec_helper"

module Oni
  describe Controller do
    [:get, :put, :post, :delete, :head, :options, :patch].each do |request_method|
      it "processes '#{request_method}' requests" do
        controller = Controller.new
        controller.should_receive(request_method)
        request = Rack::Request.new({"REQUEST_METHOD" => "#{request_method.upcase}"})
        controller.process(request)
      end
    end

    it "wraps the response from the request method" do
      controller = Controller.new
      controller.should_receive(:get).and_return "some funky html and stuff"
      request = Rack::Request.new({"REQUEST_METHOD" => "GET"})
      response = mock(:response)
      Rack::Response.should_receive(:new).with(["some funky html and stuff"]).and_return(response)
      controller.process(request).should == response
    end
  end
end
