require File.dirname(__FILE__) + "/../spec_helper"

module MCPackage
    describe Package do
        describe "#package_type" do
            it "should identify an agent package" do
                Dir.stubs(:mktmpdir).returns(true)
                File.stubs(:directory?).returns(true)

                package = Package.new("testpackage", "1")
                package.package_type
                package.plugin_type.should == :agent
            end

            it "should identify all the other packages" do
                1.should == 2
            end
        end

        describe "#clean_up" do
            it "should remove tmpdir it created" do
                Dir.stubs(:mktmpdir).returns("tmp")
                FileUtils.stubs(:rm_r).returns("true")
                FileUtils.expects(:rm_r).with("tmp").returns("true")

                package = Package.new("testpackage", "1")
                package.clean_up
            end

            it "should raise an exception if tmpdir can't be removed" do
                1.should == 2
            end
        end
    end
end
