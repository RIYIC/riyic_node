module Riyic
    class Check::ExternalPort < Riyic::Check
        # para incluir o setters automaticos
        extend Riyic::AttributeMixin
        include Riyic::ShellMixin
    
        attr_setter :open, :protocol
    
        def initialize(node,port, &block)
            @node = node
            @port = port
            @open = true
            @protocol = "tcp"
    
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando o porto #{@port} do nodo #{@node.name} desde o exterior"

            # seteamos as flags segun o protocolo (tcp ou udp)
            flag_proto = (@protocol == 'tcp')? '-sS' : '-sU'

            stdout = run_cmd %W[nmap -p #{@port} #{flag_proto} #{@node.ip} -oN -]
            state = nil

            if stdout =~ /#{@port}\/#{@protocol}\s+(\w+)\s+/
                state = $1
            else
                raise "Nmap output invalid : #{stdout}"
            end

            expected_state = (@open)? 'open' : 'closed'
            ok if state == expected_state

            # si non se cumpliron as condicions 
            ko

            @status
        end
    end
end
