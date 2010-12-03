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
        parts.should == { :tags => "beer", :amount => 55 }
      end
    end
  end
end
