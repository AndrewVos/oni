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
        response = mock(:response).as_null_object
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

      it "exposes the request" do
        subject.stub!(:get)
        subject.process(request)
        subject.request.should == request
      end
    end

    describe ".render" do
      it "returns rendered templates" do
        template = mock(:template)
        Template.stub!(:new).with(:index).and_return(template)
        template.stub!(:render).and_return("rendered template")
        subject.render(:index).should == "rendered template"
      end

      it "passes the binding through to the template" do
        template = mock(:template)
        Template.stub!(:new).and_return(template)
        subject.should_receive(:method1)
        template.stub!(:render) do |controller_binding, options|
          controller_binding.method1
        end
        subject.stub!(:method1)
        subject.render(:index)
      end

      it "passes the options through to the template" do
        template = mock(:template)
        Template.stub!(:new).and_return(template)
        template.stub!(:render) do |controller_binding, options|
          options.should == {:layout => false}
        end
        subject.render(:index, :layout => false)
      end
    end

    describe ".content_type" do
      context "with a file extension" do
        it "sets the content type" do
          subject.content_type(".css")
          subject.stub!(:get)
          subject.process(request)["Content-Type"].should == "text/css"
        end
      end

      context "with a content type" do
        it "sets the content type" do
          subject.content_type("text/xml")
          subject.stub!(:get)
          subject.process(request)["Content-Type"].should == "text/xml"
        end
      end
    end
  end
end
