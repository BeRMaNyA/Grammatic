require 'treetop'

module Grammatic
  module Helpers
    def format_output(result, type = :string)
      raise "can't be a nil element" if result.nil?

      text_value = result.text_value

      if type == :string
        text_value.squeeze(" ").strip
      elsif type == :integer
        text_value.to_i
      else
        raise "can't return a formatted output"
      end
    end

    def has_description?(result)
      result.respond_to?('description') && !result.description.text_value.blank?
    end
  end

  module Grammar
    include Grammatic::Helpers

    class Transaction < Treetop::Runtime::SyntaxNode
    end

    class Expense < Transaction
      def to_json
        { :account => format_output(expense.account), :tags => format_output(expense.tags), :amount => format_output(expense.debit, :integer) }
      end
    end

    class Deposit < Transaction
      def to_json
        { :account => format_output(deposit.account), :tags => format_output(deposit.tags), :amount => format_output(deposit.credit, :integer) }
      end
    end

    class Transfer < Transaction
      def to_json
        { :from => format_output(transfer.from), :to => format_output(transfer.to), :ammount => format_output(transfer.amount, :integer) }
      end
    end

    class Exchange < Transaction
    end
  end

  def self.parse(expression)
    Treetop.load 'grammar/budgeteer'

    parser = BudgeteerGrammarParser.new
    result = parser.parse(expression)

    raise "The expression is not valid" if result.nil?

    parts = result.to_json
    parts[:description] = format_output(result.description) if has_description?(result)
    parts
  end
end
