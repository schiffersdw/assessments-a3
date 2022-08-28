require 'zip'

class ZipHelper

    def self.read(file)
        results = nil
        file_name = file.original_filename
        if(File.extname(file_name) == ".zip")
        
            #Move storage folder
            target_path = File.join("storage/", file_name)
            File.open(target_path, "wb") { |f| f.write(file.read) }
            
            #Extract files into folder
            folder_dict = ""
            Zip::File.open(target_path) do |zip_file|
                zip_file.each do |f|
                    f_path = File.join("storage", f.name)
                    folder_dict = File.dirname(f_path)
                    FileUtils.mkdir_p(folder_dict)
                    zip_file.extract(f, f_path) unless File.exist?(f_path)
                end
            end
            
            #Read contents into folder
            files = Dir.entries(folder_dict).map{|entry| "#{folder_dict}/#{entry}"}
            return true, files
        else
            return false, results
        end
    end

end