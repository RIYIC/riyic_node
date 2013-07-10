module Riyic
    class Check::File < Riyic::Check
        # para incluir o setters automaticos
        extend Riyic::AttributeMixin
    
        attr_setter :exists, :mode, :owner, :group, :type
    
        def initialize(node,file, &block)
            @node = node
            @file = file
        
            # default values
            @exists = true
            @mode = 0755
            @owner = "root"
            @group = "root"
            @type = "file"
            @status = nil
    
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando o ficheiro #{@file} dentro do nodo #{@node.name}"
            
            info = nil
            begin
                info = @node.ssh("ls -l #{@file}")
            rescue
                if ! @exists 
                    ok
                else
                    ko
                end
                return
            end
            
            # chequear tipo 
            case @type
            when "link"
                ok if info =~ /^l/
            when "dir"
                ok if info =~ /^d/
            when "file"
                ok if info =~ /^\-/
            end

            # se non se estableceu o status seteamos ko
            ko
            
            @status
        end

        # def ok
        #     @status = 'OK' unless @status
        # end

        # def ko
        #     @status = 'KO' unless @status
        # end

    end
end
