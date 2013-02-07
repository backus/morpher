class Ducktrap
  # Ducktrap that returns last result of a chain and stops on first failure.
  # Acts like AND with multiple inputs.
  class Block < self
    include Nary

    # Return inverse ducktrap
    #
    # @return [Ducktrap]
    #
    # @api private
    #
    def inverse
      self.class.new(inverse_body)
    end

    # Result of chained ducktraps
    class Result < Nary::Result

    private

      # Calculate result
      #
      # @return [Object]
      #   if successful
      #
      # @return [Error]
      #   otherwise
      #
      # @api private
      #
      def process
        original_input = input
        body.inject(original_input) do |input, ducktrap|
          result = ducktrap.run(input)

          unless result.successful?
            return Nary::MemberError.new(context, original_input, result)
          end

          result.output
        end
      end
    end
  end
end
