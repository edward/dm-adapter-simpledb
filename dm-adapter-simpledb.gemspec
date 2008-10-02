Gem::Specification.new do |s|
  s.name     = "dm-adapter-simpledb"
  s.version  = "0.9.3"
  s.date     = "2008-10-01"
  s.summary  = "A DatMapper adapter for SimpleDB"
  s.email    = "jeremy@jeremyboles.com"
  s.homepage = "http://github.com/jeremyboles/dm-adapter-simpledb"
  s.description = "A DataMapper adapter for Amazon's SimpleDB"
  s.has_rdoc = true
  s.authors  = ["Jeremy Boles"]
  s.files    = ["lib/simpledb_adapter.rb", 
		"README", 
		"Rakefile", 
		"dm-adapter-simpledb.gemspec"]
  s.test_files = ["spec/simpledb_adapter_spec.rb", 
      "spec.opts",
      "spec_helper.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["README.txt"]
  s.add_dependency("rspec", ["> 0.0.0"])
  s.add_dependency("dm-core", ["> 0.0.0"])
  s.add_dependency("aws-sdb", ["> 0.0.0"])
end