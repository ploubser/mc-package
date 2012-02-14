module MCPackage
  class DDL

    require 'mcollective'

    attr_accessor :meta

    def initialize(name)

      unless File.exist?(File.join("agent", "#{name}.ddl"))
        raise "DDL file does not exist. Cannot build package."
      else
        ddl = MCollective::RPC::DDL.new("package", false)
        ddl.instance_eval File.read(File.join("agent","#{name}.ddl"))
        @meta = ddl.meta
      end
    end

  end
end
