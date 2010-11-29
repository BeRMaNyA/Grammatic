require 'rspec'
require 'treetop'
require 'grammatic'

def assert_parses(text)
  @syntax_tree = @parser.parse(text)
end

def assert_not_parses(text)
  @parser.parse(text).should be_nil
end
