require "spec_helper"

module MCPackage
  describe DDL do
    describe "#initialize" do
      it "should raise an exception if the ddl file does not exist" do
        expect{
          DDL.new("testpackage")
        }.to raise_error "DDL file does not exist. Cannot build package."
      end
      it "should set instance variable, meta, if ddl file is present" do
        File.stubs(:join).returns("testpackage")
        File.stubs(:exist?).with("testpackage").returns(true)
        File.stubs(:read).with("testpackage").returns("metadata :name => \"testpackage\",
                                                                :description => \"Test Package\",
                                                                :author => \"Test\",
                                                                :license => \"Apache 2\",
                                                                :version => \"0\",
                                                                :url => \"foo.com\",
                                                                :timeout => 5")
        ddl = DDL.new("testpackage")
        ddl.meta[:name].should == "testpackage"
        ddl.meta[:description].should == "Test Package"
        ddl.meta[:author].should == "Test"
        ddl.meta[:license].should == "Apache 2"
        ddl.meta[:version].should == "0"
        ddl.meta[:url].should == "foo.com"
        ddl.meta[:timeout].should == 5
      end
    end
  end
end
