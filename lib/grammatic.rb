require 'treetop'

module Grammatic
  module Grammar
    class Transaction < Treetop::Runtime::SyntaxNode
    end

    class Expense < Transaction
    end

    class Deposit < Transaction
    end

    class Transfer < Transaction
    end

    class Exchange < Transaction
    end
  end
end
