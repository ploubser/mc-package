# The Marionette Collective Packge Tool
#
# Basic implementaion of rpm package creation.
module MCPackage
  class Redhat < Package

    def initialize(name, post_install, iteration, vendor = nil)
      libdir = "/usr/libexec/mcollective/mcollective/"
      super(name, libdir, post_install, iteration)
      @vendor = vendor || "Puppet Labs"
    end

    # Creates all defined packages
    def create_package
      #TODO: Deal with fpm output
      create_dependencies if @dependencies
      FPM::Program.new.run params("agent") if @agent
      FPM::Program.new.run params("client") if @application
    end

    # Creates the common package for other packages to depend on
    def create_dependencies
      FPM::Program.new.run dep_params
    end

    # Construct parameter array used by fpm for standard packages
    def params(dir)
      params = standard_flags(dir)
      params += mcollective_dependencies(dir)
      params += ["-d", "mcollective-#{@name}-common >= #{meta[:version]}"] if @dependencies
      params += ["--post-install", @post_install] if @post_install
      params += metadata
      params << File.join(@libdir, (dir == "client") ? "application" : dir)
    end

    # Constructs parameter array
    def dep_params
      params = standard_flags
      params += metadata
      params += mcollective_dependencies('common')
      params << File.join(@libdir, "util")
    end

    # Options common to all type of rpm packages created by fpm
    def standard_flags(dir = "common")
      params = ["-s", "dir", "-C", @tmp_dir, "-t", "rpm", "-a", "all", "-n", "mcollective-#{@name}-#{dir}", "-v",
        @meta[:version], "--iteration", @iteration]
    end

    # Meta data from mcollective
    def metadata
      ["--url", @meta[:url], "--description", @meta[:description], "--license", @meta[:license],
        "--maintainer", @meta[:author], "--vendor", @vendor]
    end

    # Package dependencies on specific parts of mcollective
    # TODO: Consider moving this up to package when we've added more complex plugin types
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
