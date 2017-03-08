require 'spec_helper'
require 'tempfile'

module ShelloutTypes
  describe File do
    let(:regular_file) { described_class.new(Tempfile.new('a-file').path) }

    describe '#file?' do
      context 'when the file is a regular file' do
        it 'returns true' do
          expect(regular_file.file?).to be_truthy
        end
      end

      context 'when the file is not there' do
        let(:absent_file) { described_class.new('not-real') }

        it 'returns false' do
          expect(absent_file.file?).to be_falsey
        end
      end

      context 'when the file is actually a directory' do
        let(:directory_file) { described_class.new(Dir.mktmpdir('a-dir')) }

        it 'returns false' do
          expect(directory_file.file?).to be_falsey
        end
      end
    end

    describe '#owned_by?' do
      context 'when the provided user owns the file' do
        let(:current_user) { Etc.getpwuid(Process.uid).name }

        it 'returns true' do
          expect(regular_file.owned_by?(current_user)).to be_truthy
        end
      end

      context 'when the provided user does not own the file' do
        it 'returns true' do
          expect(regular_file.owned_by?('fake-user')).to be_falsey
        end
      end
    end

    describe '#content' do
      let(:file_with_content) do
        a_file = Tempfile.new('a-file')
        a_file.write("here is\nmy content")
        a_file.flush
        described_class.new(a_file.path)
      end

      it 'returns the file content' do
        expect(file_with_content.content).to eq("here is\nmy content")
      end
    end

    describe '#mode?' do
      context 'when the file mode has matching u/g/o bits' do
        it 'returns true' do
          expect(regular_file.mode?(0600)).to be_truthy
        end
      end

      context 'when the file mode has some other u/g/o bits' do
        it 'returns false' do
          expect(regular_file.mode?(0777)).to be_falsey
        end
      end
    end

    describe '#group' do
      let(:current_group) { Etc.getgrgid(Process.gid).name }

      it 'returns the group of the file' do
        expect(regular_file.group).to eq(current_group)
      end
    end

    describe '#executable?' do
      context 'when the file is executable' do
        let(:executable_file) do
          file_path = Tempfile.new('a-file').path
          ::File.chmod(0700, file_path)
          described_class.new(file_path)
        end

        it 'returns true' do
          expect(executable_file.executable?).to be_truthy
        end
      end

      context 'when the file is not executable' do
        it 'returns false' do
          expect(regular_file.executable?).to be_falsey
        end
      end
    end
  end
end
