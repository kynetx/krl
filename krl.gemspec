require 'rake'

Gem::Specification.new do |s|
  s.name = %q{krl}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Farmer, Cid Dennis"]
  s.date = %q{2010-12-21}
  s.email = %q{mjf@kynetx.com}
  s.extra_rdoc_files = ["LICENSE"]
  s.homepage = %q{http://github.com/kynetx/krl}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.bindir = 'bin'
  s.executables = ['krl', 'krl-connect']
  s.rubygems_version = %q{1.3.5}
  s.has_rdoc = false
  s.summary = %q{Provides terminal access to the Kynetx Applicaiton API}

  s.description = <<-EOF
    Build your Kynetx applications with the IDE of your choice! Installing the krl gem will give you 
    command line tools that provides a simple interface that is similar to git or svn.
  EOF

  s.files = FileList['lib/**/*.rb', 'bin/**/**', "LICENSE"].to_a

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<kynetx_am_api>, [">= 0.1.30"])
      s.add_runtime_dependency(%q<terminal-table>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 1.0"])
      s.add_runtime_dependency(%q<launchy>, [">= 0.3.7"])
      s.add_runtime_dependency(%q<awesome_print>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, [">= 0.14.6"])
      s.add_development_dependency('rspec')
    else
      s.add_dependency(%q<kynetx_am_api>, [">= 0.1.30"])
      s.add_dependency(%q<terminal-table>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 1.0"])
      s.add_dependency(%q<launchy>, [">= 0.3.7"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0.14.6"])
      s.add_development_dependency('rspec')
    end
  else
    s.add_dependency(%q<kynetx_am_api>, [">= 0.1.29"])
    s.add_dependency(%q<terminal-table>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 1.0"])
    s.add_dependency(%q<launchy>, [">= 0.3.7"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0.14.6"])
    s.add_development_dependency('rspec')
  end
end
