require 'rubygems'
require 'spec'
require 'spec/rake/spectask'
require 'pathname'
require "rake/gempackagetask"

ROOT = Pathname(__FILE__).dirname.expand_path
require ROOT + 'lib/simpledb_adapter'

task :default => [ :spec ]

desc 'Run specifications'
Spec::Rake::SpecTask.new(:spec) do |t|
  if File.exists?('spec/spec.opts')
    t.spec_opts << '--options' << 'spec/spec.opts'
  end
  t.spec_files = Pathname.glob((ROOT + 'spec/**/*_spec.rb').to_s)
 
  begin
    t.rcov = ENV.has_key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true
    t.rcov_opts << '--exclude' << 'spec'
    t.rcov_opts << '--text-summary'
    t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
  rescue Exception
    # rcov not installed
  end
end


spec = Gem::Specification.new do |s|
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
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["README.txt"]
  s.add_dependency("rspec", ["> 0.0.0"])
  s.add_dependency("dm-core", ["> 0.0.0"])
  s.add_dependency("aws-sdb", ["> 0.0.0"])
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc "Create a gemspec file"
task :gemspec do
  File.open("dm-adapter-simpledb.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end