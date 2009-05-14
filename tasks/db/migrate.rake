require 'sequel'

desc 'database migrate'
task :db_migrate, 'target', 'current' do |t, arg|
  target = arg.target.to_i if arg.target
  current = arg.current.to_i if arg.current
  DB = Sequel.sqlite($config[:db_path])
  Sequel::Migrator.apply(DB, 'db/migrations', target, current)
end

