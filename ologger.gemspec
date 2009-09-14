# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ologger}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew Rudenko"]
  s.date = %q{2009-09-04}
  s.description = %q{}
  s.email = %q{ceo@prepor.ru}
  s.files = [
    "Rakefile",
     "Readme.rdoc",
     "VERSION",
     "lib/ologger.rb",
     "lib/ologger/buffer.rb",
     "lib/ologger/middleware.rb",
     "lib/ologger/object_methods.rb",
     "lib/ologger/parser.rb",
     "lib/ologger/raise_patch.rb",
     "memory",
     "olog.gemspec",
     "ologger.gemspec",
     "pkg/olog-0.1.0.gem",
     "pkg/ologger-0.1.0.gem",
     "test/test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/prepor/olog}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Object separated logs}
  s.test_files = [
    "test/test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
