module AttributeMixin

    # hai que usar o hook "included" para poder insertar metodos de clase
    # xa que os metodos de clase se insertar "extendendo"
    # e por defecto os mixin se "incluen" => solo os ve unha instancia

    def self.included base
        #base.send :include, InstanceMethods
        base.extend ClassMethods
    end

    module ClassMethods
        def attr_setter(*method_names)
            method_names.each do |name|
                send :define_method, name do |data|
                    instance_variable_set "@#{name}".to_sym, data 
                end
            end
        end
        
        def varargs_setter(*method_names)
            
            method_names.each do |name|
                send :define_method, name do |*data|
                    instance_variable_set "@#{name}".to_sym, data 
                end
            end
        end
    end

end
