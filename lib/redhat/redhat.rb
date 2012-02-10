module MCPackage
    class RedHat < Package

        def create_package
            #Send stdout to a log file. Keep on failure
            FPM::Program.new.run params
            clean_up
        end

        def params
            params = ["-s", "dir", "-t", "rpm", "-a", "all", "-n", @name, "-v", @version]
            params += ["--post-install", @post_install] if @post_install
            params << path
        end

        def path
            case(@plugin_type)
            when :agent
                create_agent
            else
                raise "Undefined Plugin Type"
            end
        end

        def create_agent
            FileUtils.mkdir_p "#{@tmp_dir}/usr/libexec/mcollective/mcollective"
            FileUtils.cp_r "agent", "#{@tmp_dir}/usr/libexec/mcollective/mcollective"
            FileUtils.cp_r "application", "#{@tmp_dir}/usr/libexec/mcollective/mcollective"
            "#{@tmp_dir}/usr/libexec/mcollective/mcollective"
        end
    end
end
