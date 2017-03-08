module ShelloutTypes
  class File
    def initialize(path)
      @path = path
    end

    def file?
      @is_file ||= ::File.file?(@path)
    end

    def owned_by?(username)
      @owner ||= Etc.getpwuid(::File.stat(@path).uid)
      @owner.name == username
    end

    def content
      @content ||= ::File.read(@path)
    end

    def mode?(expected_mode)
      expected_mode == (::File.stat(@path).mode & 0777)
    end

    def group
      @group_name ||= Etc.getgrgid(::File.stat(@path).gid).name
    end

    def executable?
      ::File.stat(@path).mode & 
    end
  end
end
