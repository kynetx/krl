module KRL_CMD
  class Update
    def self.go(args)
      version = args.to_s.empty? ? "development" : args.to_s.to_i
      require LIB_DIR + 'common'
      app = KRL_COMMON::get_app
      root_dir = Dir.pwd
      File.open(File.join(Dir.pwd, app.application_id + ".krl"), "w") { |f| f.print(app.krl(version)) }
      puts "Updated to version: #{version}"
    end
  end
end