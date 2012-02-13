module MCPackage
    class Debian < Package

        def initialize(name, version, post_install)
            mc_path = "usr/share/mcollective/plugins/mcollective"
            super(name, version, mc_path, post_install)
        end
        def create_package
            #Send stdout to a log file. Keep on failure
            FPM::Program.new.run params
        end

        def params
            #Standard fpm flags
            params = ["-s", "dir", "-C", @tmp_dir, "-t", "deb", "-a", "all", "-n", @name, "-v", @version]
            #Post install scripts
            params += ["--post-install", @post_install] if @post_install
            params << @mc_path
        end
    end
end
