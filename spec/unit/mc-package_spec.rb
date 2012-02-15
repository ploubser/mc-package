require "spec_helper"

module MCPackage
  describe MCPackage do

    describe "#create_package" do
      before do
        Facter.expects(:value).with("osfamily").returns('Foo')
        File.expects(:basename).returns("tmp")
        @mc_package = mock()
        @mc_class = mock()
        MCPackage.expects(:const_get).returns(@mc_class)
        @mc_class.expects(:new).returns(@mc_package)
      end

      after do
        MCPackage::create_package({})
      end

      it "should create an instance of a package class and run clean_up" do
        Mocha::Mock.expects(:superclass).returns MCPackage::Package
        @mc_package.expects(:initialized).returns(true)
        @mc_package.expects(:libdir).returns("libdir")
        @mc_package.stubs(:create_package)
        @mc_package.expects(:clean_up)
      end

      it "should raise an exception if package doesn't extend MCPackage::Package" do
        MCPackage.expects(:puts).with("Mocha::Mock must extend MCPackage::Package. Aborting")
      end

      it "should raise an exception if MCPacakge::Package.initialize hasn't been called" do
        Mocha::Mock.expects(:superclass).returns MCPackage::Package
        @mc_package.expects(:initialized).returns(false)
        MCPackage.expects(:puts).with("Mocha::Mock must call MCPackage::Package.initialize(). Aborting")
      end

      it "should raise an exception if MCPackage::Package.libdir is nil" do
        Mocha::Mock.expects(:superclass).returns MCPackage::Package
        @mc_package.expects(:initialized).returns(true)
        @mc_package.expects(:libdir).returns(nil)
        MCPackage.expects(:puts).with("libdir must be set in super() call in class Mocha::Mock. Aborting")
      end

      it "should not run clean_up if mc_package is nil" do
        MCPackage.stubs(:puts)
        @mc_package.expects(:clean_up).never
      end
    end
  end
end
