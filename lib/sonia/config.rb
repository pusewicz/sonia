module Sonia
  # Simple configuration class
  #
  # @example
  #   "Config.new({:name => "Piotr"}).piotr" #=> "Piotr"
  class Config
    # @param [Hash] data Hash containing configuration data
    def initialize(data={})
      @data = {}
      update!(data)
    end

    # Updates configuration data
    #
    # @param [Hash] data
    def update!(data)
      data.each do |key, value|
        self[key] = value
      end
    end

    # Returns configuration value
    #
    # @param [#to_sym] key Key of the value
    def [](key)
      @data[key.to_sym]
    end

    # Allows setting a value
    #
    # @param [#to_sym] key Key of the value
    # @param [Object] value Configuration value
    def []=(key, value)
      if value.class == Hash
        @data[key.to_sym] = Config.new(value)
      else
        @data[key.to_sym] = value
      end
    end

    # Returns each configuration key - value pair or an iterator
    #
    # @yield [key, value]
    # @param [Enumerator]
    def each
      if block_given?
        @data.each do |k, v|
          yield k, v
        end
      else
        @data.each
      end
    end

    # Returns configuration value by missing method name
    #
    # @param [Symbol] sym Key name as symbol
    # @return [Object]
    def method_missing(sym, *args)
      if sym.to_s =~ /(.+)=$/
        self[$1] = args.first
      else
        self[sym]
      end
    end

    # Returns whole configuration data as hash
    #
    # @return [Hash]
    def to_hash
      @data
    end
  end
end
