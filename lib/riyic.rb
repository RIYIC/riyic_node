require "oj"
require "net/ssh"
require "mixlib/shellout"
require "do_api"

require "riyic/colorized_strings"
require "riyic/attribute_mixin"
require "riyic/shell_mixin"

require "riyic/api"
require "riyic/driver/lxc"
require "riyic/driver/digitalocean"
require "riyic/node"
require "riyic/exec"

require "riyic/check"
require "riyic/check/file"
require "riyic/check/command"
require "riyic/check/external_command"
require "riyic/check/port"
require "riyic/check/external_port"
require "riyic/check/process"

module Riyic
    $debug = false

    class << self
        def build_node(name, &block)
            puts "DEBUG ENABLED" if $debug
            
            # para encadenar test, si xa esta seteado o nodo na clase devolvemolo
            if node = Riyic::Node.get_node
                return node
            else
                return Riyic::Node.new(name, &block)
            end
        end

        def enable_debug
            $debug = true
        end

        def set_node(node)
            Riyic::Node.set_node(node)
        end

    end

end
