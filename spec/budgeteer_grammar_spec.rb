require 'spec_helper'

include Grammatic::Grammar

Treetop.load 'grammar/budgeteer'

describe "Budgeteer's grammar" do
  before(:all) do
    @parser = BudgeteerGrammarParser.new
  end

  describe "parsing expenses should recognize" do
    after do
      Expense.should === @syntax_tree
    end

    it "minimal correct input" do
      assert_parses "super 100"
    end

    it "full correct input" do
      assert_parses "@savings super food 100 some groceries for tonight"
    end

    it "missing description" do
      assert_parses "@savings super 100"
    end

    it "more than one tag" do
      assert_parses "@savings super gift kids 100"
    end

    it "the optional '-' sign" do
      assert_parses "super -100"
    end

    it "the optional '-' sign separated from the amount" do
      assert_parses "super - 100"
    end

    it "installments" do
      assert_parses "clothes 1200/3"
    end

    it "installments with spaces and description" do
      assert_parses "clothes 1200 / 3 jeans for dad and mom"
    end
  end

  describe "parsing deposits should recognize" do
    after do
      Deposit.should === @syntax_tree
    end

    it "the '+' sign" do
      assert_parses "@savings salary +1000 august income"
    end

    it "the '+' sign separated from the amount" do
      assert_parses "@savings salary + 1000 august income"
    end
  end

  describe "parsing transfers should recognize" do
    after do
      Transfer.should === @syntax_tree
    end

    it "a normal transfer" do
      assert_parses "@savings @cash 3500 to pay coworking space"
    end

    it "not including a description" do
      assert_parses "@savings @cash 3500"
    end
  end

  describe "parsing exchanges should recognize" do
    after do
      Exchange.should === @syntax_tree
    end

    it "a normal exchange" do
      assert_parses "@savings_in_dollars @savings_in_pesos 100 2225 so we have some pesos to spend"
    end
  end

  describe "parsing transactions in general" do
    it "should ignore excessive spaces at any point in the command sentences" do
      assert_parses "   @savings     super  food      100   some   groceries        for    tonight   "
    end

    describe "shouldn't recognize" do
      it "missing tag" do
        assert_not_parses "100"
      end

      it "missing tag but having an acount" do
        assert_not_parses "@savings 100"
      end

      it "missing amount" do
        assert_not_parses "super"
      end

      it "account mixed between tags" do
        assert_not_parses "super @savings kids 100"
      end

      it "account after tags" do
        assert_not_parses "super @savings 100"
      end

      it "amount before account" do
        assert_not_parses "100 @savings super"
      end

      it "mixed '-' and '+' signs" do
        assert_not_parses "salary - + 1000"
      end

      it "mixed '+' and '-' signs" do
        assert_not_parses "salary + - 1000"
      end
    end
  end
end
