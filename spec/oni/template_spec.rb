require "spec_helper"

module Oni
  describe Template do
    before do
      Dir.stub!(:glob).with("templates/index.*").and_return ["templates/index.haml", "index.erb"]
      Dir.stub!(:glob).with("templates/layout.*").and_return []
      Tilt.stub!(:new).with("templates/index.haml").and_return(tilt)
    end

    let :tilt do
      tilt = mock(:tilt)
      tilt.stub!(:render).and_return("rendered template")
      tilt.stub!(:default_mime_type)
      template_class = mock(:template_class)
      template_class.stub!(:default_mime_type).and_return("mime type")
      tilt.stub!(:class).and_return(template_class)
      tilt
    end

    context "without a layout template" do
      it "renders the first template found" do
        tilt.stub!(:render).and_return("rendered template")
        Template.new(:index).render(nil).body.should == "rendered template"
      end

      it "passes the scope through to the template renderer" do
        tilt.should_receive(:render).with("scope")
        Template.new(:index).render("scope")
      end
    end

    it "returns the content type" do
      tilt.stub!(:render)
      Template.new(:index).render(nil).content_type.should == "mime type"
    end

    context "with a layout template" do
      before do
        Dir.stub!(:glob).with("templates/layout.*").and_return ["templates/layout.haml"]
        Tilt.stub!(:new).with("templates/layout.haml").and_return(layout_tilt)
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
        Template.new(:index).render(nil).body.should == "layout with something inside"
      end

      it "passes the scope through to the layout template" do
        layout_tilt.should_receive(:render).with("scope")
        Template.new(:index).render("scope")
      end

      context "with the template option turned off" do
        it "does not render the template inside the layout template" do
          layout_tilt.should_not_receive(:render)
          Template.new(:index).render(nil, {:layout => false})
        end
      end
    end

    context "with a specific layout template" do
      before do
        Dir.stub!(:glob).with("templates/specific_layout.*").and_return ["templates/specific_layout.haml"]
        Tilt.stub!(:new).with("templates/specific_layout.haml").and_return(specific_layout)
      end

      let :specific_layout do
        specific_layout = mock(:specific_layout)
        specific_layout.stub!(:render)
        specific_layout
      end

      it "renders the specific layout template" do
        specific_layout.should_receive(:render)
        Template.new(:index).render(nil, {:layout => :specific_layout})
      end
    end
  end
end
