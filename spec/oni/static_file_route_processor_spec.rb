require "spec_helper"

module Oni
  describe StaticFileRouteProcessor do
    subject { StaticFileRouteProcessor.new(request) }

    before do
      StaticFileController.stub!(:new).and_return(controller)
    end

    let :request do
      mock(:request)
    end

    let :controller do
      mock(:controller)
    end

    context "with a file that exists" do
      it "passes the request on to the controller" do
        request.stub!(:path).and_return("/main.css")
        File.stub!(:exist?).with(File.expand_path("public/main.css")).and_return(true)
        File.stub!(:read).with(File.expand_path("public/main.css")).and_return "file contents"
        controller.should_receive(:process).with(request)
        subject.process?
      end

      it "returns the response of the controller" do
        request.stub!(:path).and_return("/main.css")
        File.stub!(:exist?).with(File.expand_path("public/main.css")).and_return(true)
        File.stub!(:read).with(File.expand_path("public/main.css")).and_return "file contents"
        controller.stub!(:process).and_return("hello")
        subject.process?.should == "hello"
      end

      it "only returns files that are descendants of public/" do
        request.stub!(:path).and_return("/../file.txt")
        File.stub!(:exist?).with(File.expand_path("public/../file.txt")).and_return(true)
        File.stub!(:read).and_return("file contents")
        subject.process?.should_not == "file contents"
      end
    end

    context "with a file that does not exist" do
      it "returns false" do
        request.stub!(:path).and_return("/main.css")
        File.stub!(:exist?).with(File.expand_path("public/main.css")).and_return(false)
        subject.process?.should == false
      end
    end
  end
end
