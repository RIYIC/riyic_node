module Riyic
    class Check::Command < Riyic::Check
        # para incluir o setters automaticos
        extend Riyic::AttributeMixin
    
        attr_setter :run_ok, :result
    
        def initialize(node,command,&block)
            @node = node
            @command = command
            
            @run_ok = true
            @result = nil
    
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando comando #{@command} no nodo #{@node.name}"

            stdout = nil

            begin
                stdout = @node.ssh(@command)
            rescue
                ko if @run_ok
            end


            # chequeamos si a salida coincide co esperado (si hai esperado)
            if @result
                ok if stdout == @result 
                ko
            end

            # si non se estableceu nada ata aqui e que todo foi ok
            ok

            @status
        end
    end
end
