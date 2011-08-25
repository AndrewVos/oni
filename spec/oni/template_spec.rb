module Oni
  describe Template do
    before do
      Dir.stub!(:glob).with("views/index.*").and_return ["views/index.haml", "index.erb"]
      Tilt.stub!(:new).with("views/index.haml").and_return(tilt)
    end

    let :tilt do
      tilt = mock(:tilt)
      tilt.stub!(:render).and_return("rendered template")
      tilt
    end

    context "wthout a layout template" do
      before do
        Dir.stub!(:glob).with("views/layout.*").and_return []
      end
      it "renders the first template found" do
        tilt.stub!(:render).and_return("rendered template")
        Template.new(:index).render(nil).should == "rendered template"
      end

      it "passes the scope through to the template renderer" do
        tilt.should_receive(:render).with("scope")
        Template.new(:index).render("scope")
      end
    end

    context "with a layout template" do
      before do
        Dir.stub!(:glob).with("views/layout.*").and_return ["views/layout.haml"]
        Tilt.stub!(:new).with("views/layout.haml").and_return(layout_tilt)
      end

      let :layout_tilt do
        layout_tilt = mock(:layout_tilt)
        layout_tilt.stub!(:render)
        layout_tilt
      end

      it "renders the template inside the layout template" do
        layout_tilt.should_receive(:render) do |&block|
          block.call.should == "rendered template"
        end
        Template.new(:index).render(nil)
      end

      it "returns the layout template with the template inside it" do
        layout_tilt.stub!(:render).and_return("layout with something inside")
        Template.new(:index).render(nil).should == "layout with something inside"
      end

      context "with the template option turned off" do
        it "does not render the template inside the layout template" do
          layout_tilt.should_not_receive(:render)
          Template.new(:index).render(nil, {:layout => false})
        end
      end
    end
  end
end
