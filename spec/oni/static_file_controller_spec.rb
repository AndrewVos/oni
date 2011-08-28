require "spec_helper"

module Oni
  describe StaticFileController do
    subject {StaticFileController.new}

    it "returns the file contents" do
      request = mock(:request)
      request.stub!(:params)
      request.stub!(:request_method).and_return("GET")
      request.stub!(:path).and_return("/file.css")
      File.stub!(:read).with("public/file.css").and_return("file contents")
      subject.process(request).body.should == ["file contents"]
    end

    it "sets the content type" do
      request = mock(:request)
      request.stub!(:params)
      request.stub!(:request_method).and_return("GET")
      request.stub!(:path).and_return("/file.css")
      File.stub!(:read).with("public/file.css").and_return("file contents")
      subject.should_receive(:content_type).with(".css")
      subject.process(request)
    end
  end
end
