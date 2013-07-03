module Check
    class File
        # para incluir o setters automaticos
        include AttributeMixin
    
        attr_setter :exists, :mode, :owner, :group, :type
    
        def initialize(node,file, &block)
            @node = node
            @file = file
        
            # default values
            @exists = true
            @mode = 0755
            @owner = "root"
            @group = "root"
            @type = "File"
    
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando o ficheiro #{@file} dentro do nodo #{@node.name}"
        end
    end
end
