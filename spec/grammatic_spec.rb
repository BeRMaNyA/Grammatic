require 'spec_helper'

describe "Grammatic" do
  before(:all) do
    @parser = BudgeteerGrammarParser.new
  end

  describe Expense do
    describe "giving a valid expression" do
      it "should recognize all the parts of that string" do
        parts = Grammatic.parse("@savings super food 100 some groceries for tonight")
        parts.should == { :tags => "super food", :amount => 100, :account => "@savings", :description => "some groceries for tonight" }
      end

      it "should regognize minimal correct expression" do
        parts = Grammatic.parse("beer 55")
        parts.should == { :tags => "beer", :amount => 55, :account => "" }
      end
    end
  end

  describe Deposit do
    describe "giving a valid expression" do
      it "should recognize all the parts of that string" do
        parts = Grammatic.parse("@savings salary +1000 august income")
        parts.should == { :account => "@savings", :tags => "salary", :amount => 1000, :description => "august income" }
      end
    end
  end

  describe Transfer do
    describe "giving a valid expression" do
      it "should recognize all the parts of that string" do
        parts = Grammatic.parse("@savings @cash 3500 to pay coworking space")
        parts.should == { :from => "@savings", :to => "@cash", :ammount => 3500, :description => "to pay coworking space" }
      end

      it "should recognize the expression without description" do
        parts = Grammatic.parse("@savings @cash 3500")
        parts.should == { :from => "@savings", :to => "@cash", :ammount => 3500 }
      end
    end
  end
end
