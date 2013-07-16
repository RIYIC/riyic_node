module Riyic
    class Check::ExternalCommand < Riyic::Check
        # para incluir o setters automaticos
        extend Riyic::AttributeMixin
        include Riyic::ShellMixin
    
        attr_setter :run_ok, :result

        def initialize(node,command,&block)
            @node = node
            @command = command
            
            @run_ok = true
            @result = nil
    
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando comando '#{@command}' desde o exterior contra o nodo '#{@node.name}'"

            stdout = nil

            begin
                stdout = run_cmd @command.split(' ')
            rescue
                ko if @run_ok
            end


            # chequeamos si a salida coincide co esperado (si hai esperado)
            if @result
                puts "Testeando que a salida coincida con #{@result}"
                if @result.is_a?(Regexp)
                    #puts "result e unha regexp #{@result} que ten que machear contra #{stdout}".red if $debug
                    ok if stdout =~ @result
                else
                    ok if stdout == @result
                end

                ko
            end

            # si non se estableceu nada ata aqui e que todo foi ok
            ok

            @status
        end
    end
end
