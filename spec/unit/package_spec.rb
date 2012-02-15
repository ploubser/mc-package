require "spec_helper"

module MCPackage
  describe Package do

    before do
      ddlobject = mock()
      MCPackage::DDL.stubs(:new).returns(ddlobject)
      ddlobject.stubs(:meta)

      Dir.stubs(:mktmpdir).with("mc-package").returns("foo")
      File.stubs(:join).with(Dir.pwd, "util").returns("common")
      File.stubs(:join).with(Dir.pwd, "agent").returns("agent")
      File.stubs(:join).with(Dir.pwd, "application").returns("client")

      Package.class_eval "def create_package;end"
    end

    describe "#identify_packages" do
      it "should identify a common package" do
        File.stubs(:directory?).with("common").returns(true)
        File.stubs(:directory?).with("agent").returns(false)
        File.stubs(:directory?).with("client").returns(false)
        Package.any_instance.expects(:prepare_package).with(:common).returns(true)
        Package.new("testpackage", "/tmp")
      end

      it "should identify a agent packages" do
        File.stubs(:directory?).with("common").returns(false)
        File.stubs(:directory?).with("agent").returns(true)
        File.stubs(:directory?).with("client").returns(false)
        Package.any_instance.expects(:prepare_package).with(:agent).returns(true)
        Package.new("testpackage", "/tmp")
      end

      it "should identify a client package" do
        File.stubs(:directory?).with("common").returns(false)
        File.stubs(:directory?).with("agent").returns(false)
        File.stubs(:directory?).with("client").returns(true)
        Package.any_instance.expects(:prepare_package).with(:application).returns(true)
        Package.new("testpackage", "/tmp")
      end
    end

    describe "clean_up" do
      it "should remove tmp dirs" do
        Package.any_instance.stubs(:identify_packges)
        FileUtils.expects(:rm_r).with("foo")
        package = Package.new("testpackage", "/tmp")
        package.clean_up
      end
    end

    describe "prepare_packges" do
      before do
        File.stubs(:join).with("foo", "/tmp").returns("tmpdir")
        FileUtils.stubs(:mkdir_p)
      end

      it "should copy files to tmp dirs and set @dependencies to true if util dir is present" do
        File.stubs(:directory?).with("common").returns(true)
        File.stubs(:directory?).with("agent").returns(false)
        File.stubs(:directory?).with("client").returns(false)
        FileUtils.expects(:cp_r).with("util", "tmpdir")
        package = Package.new("testpackage", "/tmp")
        package.dependencies.should == true
      end


      it "should copy files to tmp dirs and set @agent to true if agent dir is present" do
        File.stubs(:directory?).with("common").returns(false)
        File.stubs(:directory?).with("agent").returns(true)
        File.stubs(:directory?).with("client").returns(false)
        FileUtils.expects(:cp_r).with("agent", "tmpdir")
        package = Package.new("testpackage", "/tmp")
        package.agent.should == true
      end

      it "should copy files to tmp dirs and set @application to true if application dir is present" do
        File.stubs(:directory?).with("common").returns(false)
        File.stubs(:directory?).with("agent").returns(false)
        File.stubs(:directory?).with("client").returns(true)
        FileUtils.expects(:cp_r).with("application", "tmpdir")
        package = Package.new("testpackage", "/tmp")
        package.application.should == true
      end
    end
  end
end
