require 'rspec'
require 'treetop'
require 'grammatic'

include Grammatic::Grammar
Treetop.load 'grammar/budgeteer'

def assert_parses(text)
  @syntax_tree = @parser.parse(text)
  @syntax_tree.should_not be_nil
end

def assert_not_parses(text)
  @parser.parse(text).should be_nil
end
