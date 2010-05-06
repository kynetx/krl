module KRL_CMD
  class Deploy
    def self.go(args)
      version = args.to_s.empty? ? "development" : args.to_s.to_i
      require LIB_DIR + 'common'
      app = KRL_COMMON::get_app
      app.production_version = version
      puts "Deployed version: #{app.production_version}"
      
    end
  end
end