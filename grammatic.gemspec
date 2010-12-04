spec = Gem::Specification.new do |s|
  s.name = 'grammatic'
  s.version = '0.1.0'
  s.summary = "parse and recognize expressions"
  s.description = %{Parse and Recognize expressions depending of treetop grammatic}
  s.files =  [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "grammar/budgeteer.treetop",
    "lib/grammatic.rb",
    "spec/spec_helper.rb",
    "spec/grammatic_spec.rb",
    "spec/budgeteer_grammar_spec.rb"
  ]
  s.require_paths = 'lib'
  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.authors = ["Bernardo Castro"]
  s.email = "bernacas@gmail.com"
  s.homepage = "http://github.com/bermanya/grammatic"
end

