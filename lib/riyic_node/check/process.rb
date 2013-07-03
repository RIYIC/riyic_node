module Check
    class Process
        # para incluir o setters automaticos
        include AttributeMixin
    
        attr_setter :running
    
        def initialize(node, process_name , &block)
            @node = node
            @process_name = process_name
    
            @running = true
            
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando o proceso #{@process_name} dentro do nodo #{@node.name}"
        end
    end
end
