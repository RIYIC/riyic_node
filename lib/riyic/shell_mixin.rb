require 'net/ssh'
require 'mixlib/shellout'

module Riyic
    module ShellMixin
        def run_cmd(cmd)
            puts "RUN_CMD: #{cmd}" if $debug
            com = Mixlib::ShellOut.new(cmd)
            com.run_command
            com.error!
            puts "salida: #{com.stdout}" if $debug
            com.stdout
        end

        
        def ssh_connect(host, user, opts = {})
            Net::SSH.start(host, user, opts)
        end

	    def ssh_conn_open?(ssh_conn)
	    	return false unless ssh_conn and !ssh_conn.closed?
	    end

        def ssh_exec(conn, cmd, pty = $debug)
            stdout_data = ""
            stderr_data = ""
            exit_code = nil
            @ssh_conn.open_channel do |channel|
                # solicitamos pty si estamos en modo debug, ou se nos pasa a opcion
                channel.request_pty if pty

                channel.exec(cmd) do |ch, success|
                    abort "could not execute command" unless success
            
                    channel.on_data do |ch, data|
                        puts data if $debug
                        stdout_data += data
                        #channel.send_data "something for stdin\n"
                    end
            
                    channel.on_extended_data do |ch, type, data|
                        puts "STDERR: #{data}" if $debug
                        stderr_data += data
                    end

                    channel.on_request("exit-status") do |ch, data|
                        exit_code = data.read_long
                    end
                end
            end
            
            @ssh_conn.loop
            [stdout_data, stderr_data, exit_code]
                
        end

        # wrapper de ssh_exec, en caso de obter un status diferente a 0 
        # lanzamos unha excepcion co stderr, senon devolvemos stdout
        def ssh_exec!(conn,cmd)
            stdout, stderr, status = ssh_exec(conn,cmd)

            unless status == 0
                raise stderr
            end

            stdout+stderr
        end
    end
end
