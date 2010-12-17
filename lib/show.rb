module KRL_CMD
  class Show
    def self.go(options)
      version = options["version"]
      app = KRL_COMMON::get_app
      puts "KRL for version #{version}"      
      puts app.krl(version)
    end
  end
end
