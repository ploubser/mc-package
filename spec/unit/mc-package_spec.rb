require "spec_helper"

module MCPackage
  describe MCPackage do

    describe "#klass?" do
      it "should return an index if klasses contains the package type" do
        MCPackage::klass?(['foo', 'bar'], 'bar').should == 1
      end

      it "should raise and exception if klasses does not contain the package type" do
        expect{
          MCPackage::klass?(['bar', 'baz'], 'foo')
        }.to raise_error "Unsupported package type : foo"
      end
    end

    describe "#create_package" do
      before do
        Facter.expects(:value).with("osfamily").returns('Foo')
        File.expects(:basename).returns("tmp")
        MCPackage.expects(:constants).returns(['Foo', 'Bar'])
        @mc_package = mock()
        MCPackage.expects(:instance_eval).returns(@mc_package)
      end

      it "should create an instance of a package class and run clean_up" do
        Mocha::Mock.expects(:superclass).returns MCPackage::Package
        @mc_package.expects(:called).returns(true)
        @mc_package.expects(:libdir).returns("libdir")
        @mc_package.stubs(:create_package)
        @mc_package.expects(:clean_up)
        MCPackage::create_package({})
      end
      it "should raise an exception if package doesn't extend MCPackage::Package" do
          MCPackage.expects(:puts).with("Mocha::Mock must extend MCPackage::Package. Aborting")
          MCPackage::create_package({})
      end
      it "should raise an exception if MCPacakge::Package.initialize hasn't been called" do
        Mocha::Mock.expects(:superclass).returns MCPackage::Package
        @mc_package.expects(:called).returns(false)
        MCPackage.expects(:puts).with("Mocha::Mock must call MCPackage::Package.initialize(). Aborting")
        MCPackage::create_package({})
      end
      it "should raise an exception if MCPackage::Package.libdir is nil" do
        Mocha::Mock.expects(:superclass).returns MCPackage::Package
        @mc_package.expects(:called).returns(true)
        @mc_package.expects(:libdir).returns(nil)
        MCPackage.expects(:puts).with("libdir must be set in super() call in class Mocha::Mock. Aborting")
        MCPackage::create_package({})
      end
      it "should not run clean_up if mc_package is nil" do
        MCPackage.stubs(:puts)
        @mc_package.expects(:clean_up).never
        MCPackage::create_package({})
      end
    end
  end
end
