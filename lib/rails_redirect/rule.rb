class RailsRedirect
  class Rule
    DEFAULT_STATUS = 301

    Transformation = Struct.new(:value, :status) # value could be String or callable

    attr_accessor :selector
    attr_accessor :transformation

    def initialize(hash)
      @selector = hash.keys.first
      
      transformation_definition =
      if hash.values.first.is_a?(Array)
        hash.values.first
      else
        [hash.values.first]
      end

      @transformation = Rule::Transformation.new(
        transformation_definition[0],
        transformation_definition[1] || DEFAULT_STATUS
      )
    end

    def apply(path)
      new_url =
      if @transformation.value.is_a?(String)
        if @selector.is_a?(String) || @selector.is_a?(Regexp)
          path.sub(@selector, @transformation.value)
        else
          @transformation.value
        end
      elsif @transformation.value.respond_to?(:call)
        @transformation.value.call(path)
      end

      [@transformation.status, new_url, redirect_body(new_url)]
    end

    def match?(path)
      if @selector.is_a?(String)
        path == @selector
      elsif @selector.is_a?(Regexp)
        !!path[@selector]
      elsif @selector.respond_to?(:call)
        !!@selector.call(path)
      else
        false
      end
    end

    def redirect_body(url)
      "<html><body>You are being <a href=\"#{url}\">redirected</a>.</body></html>\n"
    end
  end
end
