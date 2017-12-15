module Bosh::Stemcell
  class OsImageBuilder
    def initialize(dependencies = {})
      @environment = dependencies.fetch(:environment)
      @collection = dependencies.fetch(:collection)
      @runner = dependencies.fetch(:runner)
    end

    def build(os_image_path)
      @environment.prepare_build
      @runner.configure_and_apply(@collection.operating_system_stages, ENV['resume_from'])

      shell = Bosh::Stemcell::Shell.new
      shell.run("sudo tar -cz -f #{os_image_path} -C #{@environment.chroot_dir} .")
    end
  end
end
