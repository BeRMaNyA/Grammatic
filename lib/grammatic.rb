require 'treetop'

module Grammatic
  # Raised when you enter an invalid expression
  class InvalidExpression < StandardError; end

  # Raised when you pass an invalid element to format the output
  class InvalidElement < StandardError; end

  # Raised when you pass a different element type and can't be recognized
  class CantReturnFormattedOutput < StandardError; end

  module Helpers
    # Helper method to return a formatted text_value
    def format_output(result, type = :string)
      raise InvalidElement, "can't be a nil element" if result.nil?

      text_value = result.text_value

      if type == :string
        text_value.squeeze(" ").strip
      elsif type == :integer
        text_value.to_i
      else
        raise CantReturnFormattedOutput, "can't return a formatted output"
      end
    end

    # Helper method to detect if the element has description
    def has_description?(result)
      result.respond_to?('description') && !result.description.text_value.blank?
    end
  end

  module Grammar
    include Grammatic::Helpers

    # All valid expressions are transactions
    class Transaction < Treetop::Runtime::SyntaxNode
    end

    # Parse a expression which belongs to a expense rule
    class Expense < Transaction
      def to_json
        { :account => format_output(expense.account), :tags => format_output(expense.tags), :amount => format_output(expense.debit, :integer) }
      end
    end

    # Parse a expression which belongs to a deposit rule
    class Deposit < Transaction
      def to_json
        { :account => format_output(deposit.account), :tags => format_output(deposit.tags), :amount => format_output(deposit.credit, :integer) }
      end
    end

    # Parse a expression which belongs to a transfer rule
    class Transfer < Transaction
      def to_json
        { :from => format_output(transfer.from), :to => format_output(transfer.to), :ammount => format_output(transfer.amount, :integer) }
      end
    end

    # Parse a expression which belongs to a exchange rule
    class Exchange < Transaction
      def to_json
        { :from => format_output(exchange.from), :to => format_output(exchange.to), :sell => format_output(exchange.sell, :integer), :buy => format_output(exchange.buy, :integer) }
      end
    end
  end

  # Return a json with the parts of the expression or
  # raise an exception if the expression is not valid
  #
  # Grammatic.parse("@savings super food 100 some groceries for tonight")
  # #=> { :account => @savings, :tags => "super food", :ammount => 100, :description => "some groceries for tonight" }

  def self.parse(expression)
    Treetop.load 'grammar/budgeteer'

    parser = BudgeteerGrammarParser.new
    result = parser.parse(expression)

    raise InvalidExpression, "The expression is not valid" if result.nil?

    parts = result.to_json
    parts[:description] = format_output(result.description) if has_description?(result)
    parts
  end
end
