class Jerakia
  module Dsl
    class Lookup
      attr_reader :policy
      attr_reader :request
      attr_accessor :lookup

      def initialize(name, policy, opts = {})
        @policy = policy
        @request = policy.clone_request
        scope   = policy.scope
        @lookup = Jerakia::Lookup.new(name, opts, @request, scope)
      end

      def self.evaluate(name, policy, opts, &block)
        lookup_block = new(name, policy, opts)
        lookup_block.instance_eval &block
        policy.submit_lookup(lookup_block.lookup)
      end

      # define the data source for the lookup
      # @api: public
      def datasource(name, opts = {})
        datasource = Jerakia::Datasource.new(name, lookup, opts)
        lookup.datasource = datasource
      end

      # give access to the lookup scope object
      # @api: public
      def scope
        lookup.scope
      end

      # pass through exposed functions from the main lookup object
      # @api: public
      def confine(*args)
        lookup.confine(*args)
      end

      def exclude(*args)
        lookup.exclude(*args)
      end

      def invalidate
        lookup.invalidate
      end

      def stop
        lookup.stop
      end

      def continue
        lookup.continue
      end

      def output_filter(*args)
        lookup.output_filter(*args)
      end

      def plugin
        lookup.plugin
      end
    end
  end
end
