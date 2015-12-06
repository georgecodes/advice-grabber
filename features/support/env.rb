require 'simplecov'
SimpleCov.start 'rails'

require 'aruba/cucumber'
require 'aruba/in_process'
require 'aruba/spawn_process'
require 'vcr'
require 'webmock'
require 'advice'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.default_cassette_options = { :record => :new_episodes }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end

class VcrFriendlyMain
  def initialize(argv, stdin, stdout, stderr, kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    $stdin = @stdin
    $stdout = @stdout
    Advice::CLI.start(@argv)
  end
end

Before('@vcr') do
  aruba.config.command_launcher = :in_process
  aruba.config.main_class = VcrFriendlyMain
end

After('@vcr') do
  aruba.config.command_launcher = :spawn
  $stdin = STDIN
  $stdout = STDOUT
  VCR.eject_cassette
end
