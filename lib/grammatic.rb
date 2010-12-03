require 'treetop'

module Grammatic
  module Grammar
    class Transaction < Treetop::Runtime::SyntaxNode
    end

    class Expense < Transaction
      def to_json
        { :tags => self.expense.tags.text_value.squeeze(" ").strip, :amount => self.expense.debit.amount.text_value.to_i }
      end
    end

    class Deposit < Transaction
    end

    class Transfer < Transaction
    end

    class Exchange < Transaction
    end
  end

  def self.parse(expression)
    include Grammatic::Grammar
    Treetop.load 'grammar/budgeteer'

    parser = BudgeteerGrammarParser.new
    result = parser.parse(expression)

    raise "The expression is not valid" if result.nil?

    parts = result.to_json
    parts[:account]     = result.expense.account.text_value.squeeze(" ").strip unless result.expense.account.text_value.blank?
    parts[:description] = result.description.text_value.squeeze(" ").strip unless result.description.text_value.blank?
    parts
  end
end
