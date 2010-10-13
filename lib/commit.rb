module KRL_CMD
  class Commit
    def self.go(args)
      require LIB_DIR + 'common'
      app = KRL_COMMON::get_app
      krl_file = File.join(Dir.pwd, app.application_id + ".krl")
      if File.exists?(krl_file)
        begin
          app.krl = File.open(krl_file, 'r') { |f| f.read }
	  			app.set_version_note(app.version, args.to_s) if args.to_s != ""
          puts "Committed version #{app.version}"
        rescue KRLParseError => e
          puts "Unable to parse your krl."
          puts "Errors:"
          puts e.parse_errors.join("\n")
        end
      else
        raise "Unable to find file: #{krl_file}"
      end
    end
  end
end
