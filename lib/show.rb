module KRL_CMD
  class Show
    def self.go(args)
      version = args.to_s.empty? ? "development" : args.to_s.to_i
      require LIB_DIR + 'common'
      app = KRL_COMMON::get_app
      puts "KRL for version #{version}"      
      puts app.krl(version)
    end
  end
end