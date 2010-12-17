module KRL_CMD
  class Deploy
    def self.go(options)
      app = KRL_COMMON::get_app
      prod_version = options["version"] ? options["version"] : app.version
      app.production_version = prod_version
      puts "Deployed version: #{app.production_version}"
    end
  end
end
