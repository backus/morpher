# encoding: UTF-8

module Morpher
  class Evaluator
    # Mixin to define parameterized nullary evaluatos
    module Parameterized

      CONCORD = Concord::Public.new(:param)

      PRINTER = lambda do |_|
        name
        indent do
          attribute :param
        end
      end

      module ClassMethods

        # Build nary nodes
        #
        # @param [Compiler] _compiler
        # @param [Morpher::Node] node
        #
        # @return [Evaluator::Nary]
        #
        # @api private
        #
        def build(_compiler, node)
          new(node.children.first)
        end

      end # ClassMethods

      # Hook called when module gets included
      #
      # @return [undefined]
      #
      # @api private
      #
      def self.included(descendant)
        descendant.class_eval do
          include CONCORD
          extend ClassMethods
          printer(&PRINTER)
        end
      end
      private_class_method :included

    end # Parameterized
  end # Evaluator
end # Morpher
