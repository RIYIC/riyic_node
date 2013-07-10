module Riyic::Driver
    
    class Lxc
        include Riyic::ShellMixin

        attr_reader :ip, :ssh_user, :sudo_password

        def initialize(name, opts)
            @name = name
            @ip = opts[:ip] || nil
            @ssh_user = 'root'
            @sudo_password = 'ubuntu'

            if opts.include?(:base)
                @action = :clone
                @base  = opts[:base]
            elsif opts.include?(:template)
                @action = :create
                @template = opts(:template)
            else
                raise "Not found neccesary attribute (:base | :template)"
            end

        end


        def create
            cmd = ['/usr/sbin/lxc-riyic.pl','-n',@name]

            case @action
            when :clone
                cmd.push('-r',@base)
                
            when :create
                cmd.push('-t', @template)
            end

            cmd.push('-a', @ip) if @ip

            run_cmd cmd
        end

        def delete
        end

    end
end
