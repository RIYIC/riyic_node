module Riyic
    class Check::Port < Riyic::Check
        # para incluir o setters automaticos
        extend Riyic::AttributeMixin
    
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

            # miramos se temos que buscar tcp ou udp
            flag = (@protocol == 'tcp')? 't' : 'u'

            begin
                @node.ssh("netstat -pan -#{flag} | fgrep '#{@interface}:#{@port}' ")
            rescue
                ko if @open
            end

            ok

            @status
        end
    end
end
