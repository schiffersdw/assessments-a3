# frozen_string_literal: true

require 'zip'

class ZipHelper
  def self.read(file)
    file_name = file.original_filename
    if File.extname(file_name) == '.zip'

      # Move storage folder
      target_path = File.join('storage/', file_name)
      File.binwrite(target_path, file.read)

      # Extract files into folder
      folder_dict = ''
      Zip::File.open(target_path) do |zip_file|
        zip_file.each do |f|
          f_path = File.join('storage', f.name)
          folder_dict = File.dirname(f_path)
          FileUtils.mkdir_p(folder_dict)
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        end
      end

      # Read contents into folder
      entries = Dir.entries(folder_dict).map { |entry| "#{folder_dict}/#{entry}" }.select { |f| File.file?(f) }
      {
        rs: true, files: entries
      }
    else
      {
        rs: false, files: nil
      }
    end
  end
end
