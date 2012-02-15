# The Marionette Collective Package Tool
#
# Packages are defined and created with meta data contained in the agent ddl file.
# A ddl file must be present to create a new package.

module MCPackage
  class DDL
    require 'mcollective'

    attr_accessor :meta

    def initialize(name)
      raise "DDL file does not exist. Cannot build package." unless File.exist?(File.join("agent", "#{name}.ddl"))

      ddl = MCollective::RPC::DDL.new("package", false)
      ddl.instance_eval File.read(File.join("agent","#{name}.ddl"))
      @meta = ddl.meta
    end
  end
end
