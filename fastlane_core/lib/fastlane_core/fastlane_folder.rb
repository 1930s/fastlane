require_relative 'ui/ui'

module FastlaneCore
  class FastlaneFolder
    FOLDER_NAME = 'fastlane'

    # Path to the fastlane folder containing the Fastfile and other configuration files
    def self.path
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - START ")
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - files in current wd = '#{Dir.glob("*")}'")
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - files in current wd/fastlane = '#{Dir.glob("#{FOLDER_NAME}/*")}'")
     
      # original check
      fastlane_folder_is_directory = File.directory?("./#{FOLDER_NAME}/")
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - fastlane_folder_is_directory =                    '#{fastlane_folder_is_directory}' (File.directory?(./FOLDER_NAME/))")
      
      # folder variants
      fastlane_folder_is_directory_no_trailing_slash = File.directory?("./#{FOLDER_NAME}")
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - fastlane_folder_is_directory_no_trailing_slash =  '#{fastlane_folder_is_directory_no_trailing_slash}' (File.directory?(./FOLDER_NAME))")
      fastlane_folder_is_directory_no_slashes_at_all = File.directory?("#{FOLDER_NAME}")
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - fastlane_folder_is_directory_no_slashes_at_all =  '#{fastlane_folder_is_directory_no_slashes_at_all}' (File.directory?(FOLDER_NAME))")
      
      # file?
      fastlane_folder_is_a_file = File.file?("./#{FOLDER_NAME}/")
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - fastlane_folder_is_a_file =                       '#{fastlane_folder_is_a_file}' (File.file?(./FOLDER_NAME/))")
      fastlane_folder_exists = File.exist?('./#{FOLDER_NAME}/')
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - fastlane_folder_exists =                          '#{fastlane_folder_exists}' (File.exist?(./FOLDER_NAME/)),")
      fastfile_exists_in_fastlane_folder = File.exist?('./#{FOLDER_NAME}/Fastfile')
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - fastfile_exists_in_fastlane_folder =              '#{fastfile_exists_in_fastlane_folder}' (File.exist?(./FOLDER_NAME/Fastfile))")
      fastfile_exists = File.exist?('Fastfile')
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - fastfile_exists =                                 '#{fastfile_exists}' (File.exist?(Fastfile))")
      
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - 1: ''")
      value ||= "./#{FOLDER_NAME}/" if fastlane_folder_is_directory
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - 2: '#{value}'")
      value ||= "./.#{FOLDER_NAME}/" if File.directory?("./.#{FOLDER_NAME}/") # hidden folder
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - 3: '#{value}'")
      value ||= "./" if File.basename(Dir.getwd) == FOLDER_NAME && File.exist?('Fastfile.swift') # inside the folder
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - 4: '#{value}'")
      value ||= "./" if File.basename(Dir.getwd) == ".#{FOLDER_NAME}" && File.exist?('Fastfile.swift') # inside the folder and hidden
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - 5: '#{value}'")
      value ||= "./" if File.basename(Dir.getwd) == FOLDER_NAME && File.exist?('Fastfile') # inside the folder
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - 6: '#{value}'")
      value ||= "./" if File.basename(Dir.getwd) == ".#{FOLDER_NAME}" && File.exist?('Fastfile') # inside the folder and hidden
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - 7: '#{value}'")
      
      puts("3 path: Dir.getwd = '#{Dir.getwd}' - END value = '#{value}'")
      puts("")
      return value
    end

    # path to the Swift runner executable if it has been built
    def self.swift_runner_path
      return File.join(self.path, 'FastlaneRunner')
    end

    def self.swift?
      return false unless self.fastfile_path
      return self.fastfile_path.downcase.end_with?(".swift")
    end

    def self.swift_folder_path
      return File.join(self.path, 'swift')
    end

    def self.swift_runner_project_path
      return File.join(self.swift_folder_path, 'FastlaneSwiftRunner', 'FastlaneSwiftRunner.xcodeproj')
    end

    def self.swift_runner_built?
      swift_runner_path = self.swift_runner_path
      if swift_runner_path.nil?
        return false
      end

      return File.exist?(swift_runner_path)
    end

    # Path to the Fastfile inside the fastlane folder. This is nil when none is available
    def self.fastfile_path
      puts("2 fastfile_path 0: Dir.getwd = '#{Dir.getwd}'")
      
      return nil if self.path.nil?

      puts("2 fastfile_path 1: Dir.getwd = '#{Dir.getwd}' - Fastfile.swift")
      
      # Check for Swift first, because Swift is #1
      path = File.join(self.path, 'Fastfile.swift')
      return path if File.exist?(path)

      puts("2 fastfile_path 2: Dir.getwd = '#{Dir.getwd}' - Fastfile ")
      
      path = File.join(self.path, 'Fastfile')
      return path if File.exist?(path)
      
      puts("2 fastfile_path 3: Dir.getwd = '#{Dir.getwd}' - nil")
      return nil
    end

    # Does a fastlane configuration already exist?
    def self.setup?
      return false unless self.fastfile_path
      File.exist?(self.fastfile_path)
    end

    def self.create_folder!(path = nil)
      path = File.join(path || '.', FOLDER_NAME)
      return if File.directory?(path) # directory is already there
      UI.user_error!("Found a file called 'fastlane' at path '#{path}', please delete it") if File.exist?(path)
      FileUtils.mkdir_p(path)
      UI.success("Created new folder '#{path}'.")
    end
  end
end
