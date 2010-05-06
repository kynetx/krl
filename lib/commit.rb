module KRL_CMD
  class Commit
    def self.go
      require LIB_DIR + 'common'
      app = KRL_COMMON::get_app
      krl_file = File.join(Dir.pwd, app.application_id + ".krl")
      if File.exists?(krl_file)
        app.krl = File.open(krl_file, 'r') { |f| f.read }
      else
        raise "Unable to find file: #{krl_file}"
      end
      puts "Committed version #{app.version}"
    end
  end
end