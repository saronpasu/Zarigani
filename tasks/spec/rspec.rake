require 'rubygems'
require 'spec/rake/spectask'

desc 'run rspec under spec dir.'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = ['spec/**/*_spec.rb']
end

