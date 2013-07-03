module Check
    class Port
        # para incluir o setters automaticos
        include AttributeMixin
    
        attr_setter :open, :protocol,:interface
    
        def initialize(node,port, &block)
            @node = node
            @port = port
            @open = true
            @protocol = "tcp"
            @interface = "0.0.0.0"
    
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando o porto #{@port} do nodo #{@node.name}"
        end
    end
end
