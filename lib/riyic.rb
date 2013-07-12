require "oj"
require "net/ssh"
require "mixlib/shellout"
require "riyic/attribute_mixin"
require "riyic/shell_mixin"
require "riyic/api"
require "riyic/driver/lxc"
require "riyic/node"
require "riyic/exec"
require "riyic/check"
require "riyic/check/file"
require "riyic/check/command"
require "riyic/check/port"
require "riyic/check/process"
require "riyic/colorized_strings"

module Riyic
    $debug = false

    class << self
        def build_node(name, &block)
            Riyic::Node.new(name, &block)
        end

        def enable_debug
            $debug = true
        end

    end

end
