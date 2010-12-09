require 'spec_helper'

describe "Grammatic" do
  before(:all) do
    @parser = BudgeteerGrammarParser.new
  end

  describe "Grammar" do
    describe Expense do
      describe "giving a valid expression" do
        it "should recognize all the parts of that string" do
          expense = @parser.parse("@savings super food 100 some groceries for tonight")
          expense.to_hash.should == { :type => "expense", :tags => "super food", :amount => 100, :account => "@savings", :description => "some groceries for tonight" }
        end

        it "should regognize minimal correct expression" do
          expense = @parser.parse("beer 55")
          expense.to_hash.should == { :type => "expense", :tags => "beer", :amount => 55, :account => "" }
        end
      end
    end

    describe Deposit do
      describe "giving a valid expression" do
        it "should recognize all the parts of that string" do
          deposit = @parser.parse("@savings salary +1000 august income")
          deposit.to_hash.should == { :type => "deposit", :account => "@savings", :tags => "salary", :amount => 1000, :description => "august income" }
        end
      end
    end

    describe Transfer do
      describe "giving a valid expression" do
        it "should recognize all the parts of that string" do
          transfer = @parser.parse("@savings @cash 3500 to pay coworking space")
          transfer.to_hash.should == { :type => "transfer", :from => "@savings", :to => "@cash", :ammount => 3500, :description => "to pay coworking space" }
        end

        it "should recognize the expression without description" do
          transfer = @parser.parse("@savings @cash 3500")
          transfer.to_hash.should == { :type => "transfer", :from => "@savings", :to => "@cash", :ammount => 3500 }
        end
      end
    end

    describe Exchange do
      describe "giving a valid expression" do
        it "should recognize all the parts of that string" do
          exchange = @parser.parse("@savings_in_dollars @savings_in_pesos 100 2225 so we have some pesos to spend")
          exchange.to_hash.should == { :type => "exchange", :from => "@savings_in_dollars", :to => "@savings_in_pesos", :sell => 100, :buy => 2225, :description => "so we have some pesos to spend" }
        end
      end
    end

    describe "calling the helper format_output" do
      it "should format the output for a given element" do
        treetop_syntax = @parser.parse("@savings stadium soccer penarol 120 pay ticket to watch my team")

        # Strings
        "stadium soccer penarol ".should == treetop_syntax.expense.tags.text_value
        "stadium soccer penarol".should   == Grammatic.format_output(treetop_syntax.expense.tags)

        # Integers
        "120 ".should == treetop_syntax.expense.debit.text_value
        120.should    == Grammatic.format_output(treetop_syntax.expense.debit, :integer)
      end

      it "should catch exceptions when the element is not valid" do
        treetop_valid_syntax = @parser.parse("@savings stadium soccer penarol 120 pay ticket to watch my team")

        # passing invalid type to format
        lambda do
          Grammatic.format_output(treetop_valid_syntax.expense.debit, :another_thing)
        end.should raise_error(Grammatic::CantReturnFormattedOutput)

        # passing nil element
        treetop_invalid_syntax = @parser.parse("invalid sintax")
        lambda do
          Grammatic.format_output(treetop_invalid_syntax.description)
        end.should raise_error(NoMethodError)
      end
    end

    it "should return true if the element has description" do
      treetop_syntax_with_description = @parser.parse("@savings stadium soccer penarol 120 pay ticket to watch my team")
      Grammatic.has_description?(treetop_syntax_with_description).should be_true

      treetop_syntax_without_description = @parser.parse("@savings stadium soccer penarol 120")
      Grammatic.has_description?(treetop_syntax_without_description).should be_false
    end
  end

  describe "calling the method parse" do
    it "should return a hash" do
      result = Grammatic.parse("@savings stadium soccer penarol 120 pay ticket to watch my team")
      result.should == { :type => "expense", :account => "@savings", :tags => "stadium soccer penarol", :amount => 120, :description => "pay ticket to watch my team" }
    end

    it "should catch exceptions" do
      lambda do
        Grammatic.parse("invalid expression")
      end.should raise_error(Grammatic::InvalidExpression)
    end
  end
end
