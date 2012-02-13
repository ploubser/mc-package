module MCPackage
    class Debian < Package

        def create_package
            #Send stdout to a log file. Keep on failure
            FPM::Program.new.run params
        end

        def params
            #Standard fpm flags
            params = ["-s", "dir", "-C", @tmp_dir, "-t", "deb", "-a", "all", "-n", @name, "-v", @version]
            #Post install scripts
            params += ["--post-install", @post_install] if @post_install
            params << @plugin_dir
        end
    end
end
