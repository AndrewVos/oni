module Oni
  describe Template do
    it "renders the first template found" do
      Dir.stub!(:glob).with("views/index.*").and_return ["views/index.haml", "index.erb"]
      tilt = mock(:tilt)
      Tilt.stub!(:new).with("views/index.haml").and_return(tilt)
      tilt.stub!(:render).and_return("rendered template")
      Template.new(:index).render(nil).should == "rendered template"
    end

    it "passes the scope through to the template renderer" do
      Dir.stub!(:glob).with("views/index.*").and_return ["views/index.haml", "index.erb"]
      tilt = mock(:tilt)
      Tilt.stub!(:new).with("views/index.haml").and_return(tilt)
      tilt.should_receive(:render).with("scope")
      Template.new(:index).render("scope")
    end
  end
end
