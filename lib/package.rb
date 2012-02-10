module MCPackage
    class Package

        require 'fileutils'
        require 'tmpdir'

        attr_accessor :name, :version, :tmp_dir, :post_install, :plugin_type

        def initialize(name, version, post_install = nil)
            @name = name
            @version = version
            @post_install = nil
            @tmp_dir = Dir.mktmpdir("mc-package")
            package_type
        end

        def package_type
            #Normal application/agent definition
            if File.directory?("#{Dir.pwd}/agent") && File.directory?("#{Dir.pwd}/application")
                @plugin_type = :agent
            end
        end

        def clean_up
            FileUtils.rm_r @tmp_dir
        end
    end
end
