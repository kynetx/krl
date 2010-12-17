require 'fileutils'
module KRL_CMD
  class Update
    def self.go(options)
      version = options["version"]
      app = KRL_COMMON::get_app
      root_dir = Dir.pwd
      krl_file = File.join(Dir.pwd, app.application_id + ".krl")

      if File.exists?(krl_file) && options["save"]
        backup_file = app.application_id + ".saved.krl"
        raise "Backup file already exists (#{backup_file}). Your krl was not updated. Please rename or delete your existing backup file." if File.exists?(backup_file)
        FileUtils.cp(krl_file, backup_file)
      end

      File.open(krl_file, "w") { |f| f.print(app.krl(version)) }
      puts "Updated to version: #{version}"
    end
  end
end
