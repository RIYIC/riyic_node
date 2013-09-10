require "do_api"

module Riyic::Driver
    
    class Digitalocean
        include Riyic::ShellMixin

        attr_reader :ip, :ssh_user, :sudo_password

        def initialize(name, opts)
            @name = name

            # intanciamos a api de digitalocean
            if opts.include?(:api_file)

                @do_api = DO::API.new(:api_file => opts[:api_file], :debug => $debug)

            elsif opts.include?(:api_key) and opts.include?(:client_id)

                @do_api = DO::API.new(:api_key => opts[:api_key],
                                      :client_id => opts[:client_id],
                                      :debug => $debug)
            else
                raise "Not found neccesary attributes (:api_file or :api_key and :client_id)"
            end


            #params opcionais
            @size_id = opts[:size_id] || DO::SIZE_512 #512MB
            @image_id = opts[:image_id] || DO::IMAGE_UBUNTU_1204_x64 #Ubuntu 12.04 x64
            @region_id = opts[:region_id] || DO::REGION_NY1 #ny1
            @ssh_key_ids = opts[:ssh_key_ids] | []

            # id do droplet en caso de cargarlo
            @droplet_id = opts[:droplet_id] || nil

            @ssh_user = "root"


        end


        def create
            droplet = @do_api.create_vps(@name, @size_id,
                                                @image_id,
                                                @region_id,
                                                @ssh_key_ids)

            @droplet_id = droplet["id"]
            @ip = droplet["ip_address"]
        end


        def delete
            unless @droplet_id
                raise "No droplet loaded"
            end
                
            @do_api.destroy_vps(@droplet_id)
        end


        def load
            return false unless @droplet_id

            droplet = @do_api.get_droplet(@droplet_id)

            @droplet_id = droplet["id"]
            @ip = droplet["ip_address"]
            @name = droplet["name"]
            @size_id = droplet["size_id"]
            @image_id = droplet["image_id"]
            @region_id = droplet["region_id"]


        end


    end
end
