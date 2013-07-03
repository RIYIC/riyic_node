require "json"
require "riyic_node/riyic"
require "riyic_node/check/file"
require "riyic_node/check/command"
require "riyic_node/check/port"
require "riyic_node/check/process"
require "riyic_node/attribute_mixin"

class RiyicNode

    include AttributeMixin

    # class method para crear uns metodos check_xxx
    # de forma dinamica, para usar o dsl vps.check_xxx
    def self.check_test(*checks)
        checks.each do |name|
            send :define_method, "check_#{name}" do |objetivo,&block|
                test = Object.const_get("Check").
                                const_get(name.capitalize).
                                    new(self,objetivo,&block)
                test.run
            end
        end
    end
    
    attr_setter :backend, :base, :ssh_key
    check_test :file, :command, :port, :process 
    
    attr_accessor :name, :node_attrs

    def initialize(name,&block)
        # defaults
        @name            = name
        @node_attrs      = {}

        @backend         = "lxc_riyic"
        @base            = "ubuntu12.04.2"
        @ssh_key         = "my_ssh_key"

        
        instance_eval(&block)
        create_vps
    end

    def converge(&block)
        r = Riyic.new(self,&block)
        
        # seteamos os atributos a partir do json do nodo
        @node_attrs = JSON.parse(r.node_json)
 
        # executamos a converxencia
        # si peta saimos cos detalles do erro
        begin
            r.converge
        rescue
            r.error
            exit(1)
        end

    end
    
      
    
    private
    def create_vps
        puts "Creando vps con nombre #{@name}, backend #{@backend}, base #{@base}"
    end

end
