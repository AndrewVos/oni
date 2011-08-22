require "spec_helper"
require "oni/application"

class ExampleController
end

module Oni
  describe Application do
    before do
      Application.reset_routes!
    end

    let :application do
      Application.new
    end

    let :browser do
      Rack::Test::Session.new(Rack::MockSession.new(application))
    end

    it "stores a list of routes" do
      Application.route :hello, "hello route!"
      Application.route :goodbye, "goodbye route!"
      Application.routes.should == {:hello => "hello route!", :goodbye => "goodbye route!"}
    end

    it "resets routes" do
      Application.route :hello, "the route"
      Application.reset_routes!
      Application.routes.should == {}
    end

    it "maps simple routes to controllers" do
      Application.route "/", ExampleController
      controller = ExampleController.new
      ExampleController.stub!(:new).and_return(controller)
      controller.should_receive(:get)
      browser.get "/"
    end

    it "404s if there is no matching controller" do
      browser.get "/doesn't-exist"
      browser.last_response.should be_not_found
    end
  end
end
