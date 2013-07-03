#agregamos o directorio actual o $LOAD_PATH
$:.unshift File.dirname(__FILE__)

require "riyic_node"

# creamos un vps para test
vps = RiyicNode.new("test") do
    backend 'lxc_riyic'
    base 'ubuntu12.04.2'
    ssh_key "mi_key_para_tests"
end

# vamos a executar unha serie de tests a ver se o nodo converge ok
# ca run_list proporcionada

# executamos a converxencia mediante o noso script riyic
vps.converge do
    #opcions para pasarlle a riyic
    json_file 'nginx_passenger.json'
    download_cookbooks false
    api_key "opcional"
    server_id "opcional"
    environment "test"
end

#cargamos os valores do nodo 
json = vps.node_attrs

# agora vamos a executar os checks
# de momento os comandos se executan dentro do nodo, accedendo por ssh
# testeamos a existencia dun ficheiro
#vps.check_file json["node"]["nginx"]["source"]["conf"] do
vps.check_file "/etc/nginx.conf" do
    exists true|false # por defecto suponhemos que testeamos existencia
    mode 0755
    owner "root"
    type "Dir|File|Link"
end

# testear a saida dun comando
vps.check_command "ruby -v" do
    run_ok true|false # por defecto ok (status_code = 0)
    result /json["node"]["rvm"]["ruby_version"]/
end

# testeamos o estado dun porto
#vps.check_port json["node"]["nginx"]["config"]["port"] do
vps.check_port "8080" do
    open true
    protocol "tcp"
    interface '0.0.0.0' #por defecto
end

#testeamos a existencia dun proceso 
vps.check_process "nome_proceso" do
    running true
end
