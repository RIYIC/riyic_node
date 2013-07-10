module Riyic
    class Check::Process < Riyic::Check
        # para incluir o setters automaticos
        extend Riyic::AttributeMixin
    
        attr_setter :running
    
        def initialize(node, process_name , &block)
            @node = node
            @process_name = process_name
    
            @running = true
            
            instance_eval(&block)
        end
    
        def run 
            puts "Testeando o proceso #{@process_name} dentro do nodo #{@node.name}"
            begin
                @node.ssh("ps -auxwwwwf|fgrep '#{@process_name}'")
            rescue
                ko if @running
            end

            ok

            @status
        end
    end
end
