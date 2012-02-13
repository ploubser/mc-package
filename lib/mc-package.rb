module MCPackage
    require 'rubygems'
    require 'facter'
    require 'fpm/program'

    #require package classes
    require 'package'
    Dir[File.dirname(__FILE__) + "/**/*.rb"].each {|f| require f}
    def self.create_package(options)
        unless options[:ostype]
           options[:ostype] = Facter.value("osfamily")
        end

        unless options[:name]
           options[:name] = Dir.pwd.gsub(/^\/.*\//, "")
        end

        mc_package = instance_eval("MCPackage::#{options[:ostype]}.new(options[:name],
                                     options[:version], options[:postinstall])")
        begin
            mc_package.create_package
            mc_package.clean_up
        rescue Exception => e
            puts e
        end
    end

    def self.noop
    end
end
