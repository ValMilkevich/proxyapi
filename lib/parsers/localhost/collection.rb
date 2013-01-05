module Parsers::Localhost
  class Collection < Base
    attr_accessor :attributes

    def initialize(hash = {})
    end

    def index
    	puts JSON.parse doc
    end

  end
end