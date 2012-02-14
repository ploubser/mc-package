module MCPackage
    class RedHat < Package

        def initialize(name, version, post_install)
            mc_path = "usr/libexec/mcollective/mcollective/"
            super(name, version, mc_path, post_install)
        end

        def create_package
            #TODO: Deal with fpm output
            create_dependencies if @dependencies
            FPM::Program.new.run params("agent") if @agent
            FPM::Program.new.run params("application") if @application
        end

        def create_dependencies
            FPM::Program.new.run dep_params
        end

        def params(dir)
            #Standard fpm flags
            params = ["-s", "dir", "-C", @tmp_dir, "-t", "rpm", "-a", "all",
                "-n", "#{@name}-#{dir}", "-v", @version]
            #Post install scripts
            params += ["-d","#{@name}-common"] if @dependencies
            params += ["--post-install", @post_install] if @post_install
            params << "#{@mc_path}#{dir}/"
        end

        def dep_params
            params = ["-s", "dir", "-C", @tmp_dir, "-t", "rpm", "-a", "all",
                "-n", "#{@name}-common", "-v", @version, "#{@mc_path}common/"]
        end
    end
end
