require 'rspec'
require 'rspec/its'

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require(f) }

def chroot_dir
  ENV['CHROOT_DIR']
end
