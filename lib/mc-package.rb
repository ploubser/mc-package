module MCPackage
    require 'rubygems'
    require 'facter'
    require 'fpm/program'

    #require package classes
    require 'package'
    require 'redhat/redhat'

    def self.create_package(version, name = nil,type = nil)
        if type == nil
           type = Facter.value("osfamily")
        end

        if name == nil
           name = Dir.pwd.gsub(/^\/.*\//, "")
        end

        mc_package = instance_eval("MCPackage::#{type}.new(name, version, type)")
        mc_package.create_package
    end

    def self.noop
    end
end
