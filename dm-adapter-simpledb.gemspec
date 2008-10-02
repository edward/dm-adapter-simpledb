Gem::Specification.new do |s|
  s.name = %q{dm-adapter-simpledb}
  s.version = "0.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Boles"]
  s.date = %q{2008-10-01}
  s.description = %q{A DataMapper adapter for Amazon's SimpleDB}
  s.email = %q{jeremy@jeremyboles.com}
  s.extra_rdoc_files = ["README.txt"]
  s.files = ["lib/simpledb_adapter.rb", "README", "Rakefile", "dm-adapter-simpledb.gemspec", "spec/simpledb_adapter_spec.rb", "spec.opts", "spec_helper.rb", "README.txt"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jeremyboles/dm-adapter-simpledb}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A DatMapper adapter for SimpleDB}
  s.test_files = ["spec/simpledb_adapter_spec.rb", "spec.opts", "spec_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<rspec>, ["> 0.0.0"])
      s.add_runtime_dependency(%q<dm-core>, ["> 0.0.0"])
      s.add_runtime_dependency(%q<aws-sdb>, ["> 0.0.0"])
    else
      s.add_dependency(%q<rspec>, ["> 0.0.0"])
      s.add_dependency(%q<dm-core>, ["> 0.0.0"])
      s.add_dependency(%q<aws-sdb>, ["> 0.0.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["> 0.0.0"])
    s.add_dependency(%q<dm-core>, ["> 0.0.0"])
    s.add_dependency(%q<aws-sdb>, ["> 0.0.0"])
  end
end
