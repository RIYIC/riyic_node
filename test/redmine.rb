#agregamos o directorio actual o $LOAD_PATH
$:.unshift File.dirname(__FILE__)+'/riyic/lib'

require "riyic"

# habilitamos o debug
Riyic.enable_debug

# creamos un vps para test
node = Riyic.build_node("test") do
    ssh_key         "/home/alambike/.ssh/id_rsa"
    driver          'lxc'
    driver_options  :base => 'ubuntu12.04.2',
                      :ip   => "10.0.3.100"
    build_vps       false #true

end

# arreglo para non realizar o converge
# node.already_converged = true

node.converge do
    #opcions para pasarlle a ryc
    #json_file 'nginx.json'
    api_key "mSW7MbH1xVz7kGdp5rFv"
    server_id 13
    environment "dev" # test | prod | dev, por defecto test
    install     false #true # install ryc client
end

#cargamos os valores do nodo 
json = node.node_attrs


#seteamos o nodo nunha variable de clase para encadenar tests, dentro do mesmo vps
Riyic.set_node(node)

# lanzamos os test de nginx_passenger, xa que o redmine vai asociado a esos cookbooks
# e asi non temos que volver a definir todos os tests
require_relative "nginx_passenger"

# ahora metemos test propios do redmine
# pedimos o vhost donde debe estar a paxina principal do redmine (sin necesidade de que estea configurada a zona dns)
node.check_external_command "curl -L -H 'Host:#{json['redmin']['domain']}' http://#{node.ip}" do
	run_ok true
	result /Redmine/
end

node.check_external_port "80" do
	open true
	protocol 'tdp'
end





