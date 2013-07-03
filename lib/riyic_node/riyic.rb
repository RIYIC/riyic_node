module RiyicNode
    class Riyic
        # para incluir o setters automaticos
        include AttributeMixin
    
        attr_setter :environment, :download_cookbooks, :server_id, :api_key, :json_file
    
        def initialize(node,&block)
            @node = node
            @environment = "test"
            @download_cookbooks = false
            @server_id = nil
            @api_key = nil
            @json_file = nil
    
            instance_eval(&block)
        end
    
        def node_json
            #devolve ou ben o json_file ou ben a json obtido da peticion a api de riyic
            "{}"
        end
    
        def converge 
            puts "Testeando a convergencia do nodo #{@node.name}"
        end
    end
end
