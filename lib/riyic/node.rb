module Riyic

    class Node
        extend AttributeMixin
        include ShellMixin

        # class method para crear uns metodos check_xxx
        # de forma dinamica, para usar o dsl vps.check_xxx
        def self.define_check_tests(*checks)
            checks.each do |name|
                send :define_method, "check_#{name}" do |objetivo,&block|
                    # construimos o obxeto check dinamicamente
                    # p.ex: Riyic::Check::File
                    # e executamos o seu metodo run 
                    test = Object.const_get("Riyic").
                                  const_get("Check").
                                  const_get(name.capitalize).
                                        new(self,objetivo,&block)
                    status = test.run

                    puts "RESULTADO check_#{name}: ".yellow+((status == "OK")? "OK".green : "KO".red)
                end
            end
        end
        
        attr_setter :driver, :driver_options, :ssh_key, :build_vps
        define_check_tests :file, :command, :port, :process 
        attr_reader :name, :node_attrs

        def initialize(name,&block)
            # defaults
            @name                   = name
            @node_attrs             = {}
            @vps                    = nil

            # atributos a setear en el bloque
            @ssh_key                = "my_ssh_key"
            @driver                 = "lxc"
            @driver_options         = {:base => "ubuntu12.04.2",
                                       :ip   => "10.0.3.100"}
            @build_vps              = true

            
            instance_eval(&block)
            create_vps
        end

        def ssh(cmd)
            unless ssh_conn_open?(@ssh_conn)
                @ssh_conn = ssh_connect @vps.ip, @vps.ssh_user, :keys => [@ssh_key]
            end

            if cmd.is_a?(Array)
                cmd = cmd.join(" ")
            end

            puts "Enviando #{cmd} a #{@vps.ip} con el user #{@vps.ssh_user}" if $debug
            res = ssh_exec!(@ssh_conn, cmd)
            puts "Resultado:#{res}" if $debug
            res

        end

        def converge(&block)
            r = Riyic::Exec.new(self,&block)
            
            # seteamos os atributos a partir do json do nodo
            @node_attrs = Oj.load(r.node_json)
            
            puts "ATRIBUTOS A SETEAR NO NODO #{@node_attrs}" if $debug

            # executamos a converxencia
            # si peta saimos cos detalles do erro
            begin
                r.converge
            rescue Exception => e
                puts e.message
                puts e.backtrace
                exit(1)
            end
            puts "TEST CONVERGENCIA OK".green

        end
        
          
        
        private
        def create_vps
            puts "Creando vps con nombre #{@name}, driver #{@driver}, options #{@driver_options}"

            #creamos o vps dinamicamente, en funcion do driver/backend
            @vps = Object.const_get("Riyic").
                          const_get("Driver").
                          const_get(@driver.capitalize).
                                        new(@name,@driver_options)

            @vps.create if @build_vps
	        puts "CREADO OK"

            puts "TESTEANDO CONEXION A INTERNET DESDE O NODO"
            i = 0

            while i < 10 do
                return if test_salida_internet
                i+=1
            end

            raise "Vps sin salida a internet".red if i == 10
        end

        def test_salida_internet

            begin
                ssh "ping -c 3 yahoo.es"
            rescue
                sleep 1
                return false
            end

            true
        end

    end
end
