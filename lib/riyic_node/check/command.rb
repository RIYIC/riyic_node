module Check
    class Command
        # para incluir o setters automaticos
        include AttributeMixin
    
        attr_setter :run_ok, :result
    
        def initialize(node,command,&block)
            @node = node
            @command = command
            
            @run_ok = true
            @result = ""
    
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando comando #{@command} no nodo #{@node.name}"
        end
    end
end
