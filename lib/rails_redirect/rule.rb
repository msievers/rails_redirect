class RailsRedirect
  class Rule
    attr_accessor :selector
    attr_accessor :transformation

    class Selector
      attr_accessor :callable
      attr_accessor :regexp
      attr_accessor :string

      def initialize(value)
        if value.is_a?(String)
          @string = value
        elsif value.is_a?(Regexp)
          @regexp = value
        elsif value.respond_to?(:call)
          @callable = value
        else
          raise ArgumentError
        end
      end
    end

    class Transformation
      DEFAULT_STATUS = 301

      attr_accessor :callable
      attr_accessor :status
      attr_accessor :string

      def initialize(value)
        @status = DEFAULT_STATUS
        value = [value] unless value.is_a?(Array)

        if value[0].is_a?(String)
          @string = value[0]
        elsif value[0].respond_to?(:call)
          @callable = value[0]
        else
          raise ArgumentError
        end

        if value[1]
          @status =
          if value[1].is_a?(Integer)
            value[1]
          elsif value[1].is_a?(String)
            value[1].to_i
          else
            raise ArgumentError
          end
        end
      end

      def body(redirected_url)
        "<html><body>You are being <a href=\"#{redirected_url}\">redirected</a>.</body></html>\n"
      end
    end

    def initialize(*args)
      @selector, @transformation =
      if args.first.is_a?(Hash)
        [
          Selector.new(args.first.keys.first),
          Transformation.new(args.first.values.first)
        ]
      else
        binding.pry
      end
    end

    def apply(path)
      if @selector.string
        binding.pry
      elsif @selector.regexp
        if @transformation.string
          new_url = path.sub(@selector.regexp, @transformation.string)
          [@transformation.status, new_url, @transformation.body(new_url)]
        elsif @transformation.callable
          binding.pry
        else
          raise "Unknown transformation type!"
        end
      elsif @selector.callable
        binding.pry
      else
        false
      end
    end

    def match?(path)
      # order of checks is optimized by probability for early break-out (performance)
      if @selector.string
        binding.pry
      elsif @selector.regexp
        !!path[@selector.regexp]
      elsif @selector.callable
        binding.pry
      else
        false
      end
    end
  end
end
