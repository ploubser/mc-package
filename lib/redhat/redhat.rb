module MCPackage
  class RedHat < Package

    def initialize(name, post_install, iteration)
      libdir = "usr/libexec/mcollective/mcollective/"
      super(name, libdir, post_install, iteration)
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
      params = ["-s", "dir", "-C", @tmp_dir, "-t", "rpm", "-a", "all", "-n", "mcollective-#{@name}-#{dir}", "-v",
        @meta[:version], "--iteration", @iteration]
      #Dependencies
      params += mcollective_dependencies(dir)
      params += ["-d", "mcollective-#{@name}-common >= #{meta[:version]}"] if @dependencies
      #Post install scripts
      params += ["--post-install", @post_install] if @post_install
      #Package Metadata
      params += metadata
      #Package dir target
      params << File.join(@libdir, (dir == "client") ? "application" : dir)
    end

    def dep_params
      #Standard fpm flags
      params = ["-s", "dir", "-C", @tmp_dir, "-t", "rpm", "-a", "all", "-n", "mcollective-#{@name}-common", "-v",
        @meta[:version], "--iteration", @iteration]
      #Package Metadata
      params += metadata
      #Package dependencies
      params += mcollective_dependencies('common')
      #Package dir target
      params << File.join(@libdir, "util")
    end

    def metadata
      ["--url", @meta[:url], "--description", @meta[:description], "--license", @meta[:license],
        "--maintainer", @meta[:author], "--vendor", "Puppet Labs"]
    end

    def mcollective_dependencies(package_type)
      case package_type
      when 'agent'
        return ["-d", "mcollective"]
      when 'client'
        return ["-d", "mcollective-client"]
      when 'common'
        return ["-d", "mcollective-common"]
      else
        raise "Invalid package"
      end
    end
  end
end
