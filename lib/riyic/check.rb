module Riyic
    class Check

        def initialize
            @status = nil
        end

        def ok
            @status = 'OK' unless @status
        end

        def ko
            @status = 'KO' unless @status
        end
    end
end
