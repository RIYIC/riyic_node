#agregamos o directorio actual o $LOAD_PATH
$:.unshift File.dirname(__FILE__)+'/../lib'

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

# vamos a executar unha serie de tests a ver se o nodo converge ok
# ca run_list proporcionada

# executamos a converxencia mediante o noso script ryc_cli
#node.converge do
#    #opcions para pasarlle a ryc
#    #json_file 'nginx.json'
#    api_key "pDVJvAyWrXyNfft6kpAE"
#    server_id 24
#    environment "prod" # test | prod | dev, por defecto test
#    install     true # install ryc client
#end

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

# agora vamos a executar os checks
# de momento os comandos se executan dentro do nodo, accedendo por ssh

ruby_version = json["lang"]["ruby"]["version"].sub(/\-/, ' ')

# testear a saida dun comando
node.check_command "/usr/local/rvm/bin/rvm default do ruby -v" do
    #result /json["node"]["rvm"]["ruby_version"]/
    result /#{ruby_version}/
end

# testeamos o estado dun porto
#vps.check_port json["node"]["nginx"]["config"]["port"] do
node.check_port "80" do
    open true
    protocol "tcp"
    interface '0.0.0.0' #por defecto
end

#testeamos a existencia dun proceso 
node.check_process "nginx" do
    running true
end

# testeamos a existencia dun ficheiro
#vps.check_file json["node"]["nginx"]["source"]["conf"] do
node.check_file "/etc/nginx/nginx.conf" do
    exists true #true|false  por defecto suponhemos que testeamos existencia
    mode 0755
    owner "root"
    type "file" #"Dir|File|Link"
end

# chequeamos que a version de nginx instalada sexa a solicitada
node.check_command "#{json['appserver']['nginx']['install_dir']}/sbin/nginx -v" do
	run_ok true
	result /#{json['appserver']['nginx']['version']}/m
end

# testeamos qu a version de passenger sexa a solicitada
node.check_command "/usr/local/rvm/bin/rvm default do passenger -v" do
	run_ok true
	result /#{json['appserver']['nginx']['passenger']['version']}/m
end



