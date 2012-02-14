module MCPackage
  class RedHat < Package

    def initialize(name, version, post_install)
      libdir = "usr/libexec/mcollective/mcollective/"
      super(name, version, libdir, post_install)
    end

    def create_package
      #TODO: Deal with fpm output
      create_dependencies if @dependencies
      FPM::Program.new.run params("agent") if @agent
      FPM::Program.new.run params("client") if @application
    end

    def create_dependencies
      FPM::Program.new.run dep_params
    end

    def params(dir)
      #Standard fpm flags
      params = ["-s", "dir", "-C", @tmp_dir, "-t", "rpm", "-a", "all", "-n", "mcollective-#{@name}-#{dir}", "-v", @version]
      #Dependencies
      params += ["-d","mcollective-#{@name}-common >= #{@version}"] if @dependencies
      #Post install scripts
      params += ["--post-install", @post_install] if @post_install
      #Package dir target
      params << File.join(@libdir, (dir == "client") ? "application" : dir)
    end

    def dep_params
      params = ["-s", "dir", "-C", @tmp_dir, "-t", "rpm", "-a", "all", "-n", "mcollective-#{@name}-common", "-v", @version, File.join(@libdir, "util")]
    end
  end
end
