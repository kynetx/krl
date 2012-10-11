module KRL_CMD
  class Commit
    def self.go(options)
      app = KRL_COMMON::get_app
      krl_file = File.join(Dir.pwd, app.application_id + ".krl")
      if File.exists?(krl_file)
        begin
          app.krl = File.open(krl_file, 'r') { |f| f.read }
	  			app.set_version_note(app.version, options["note"]) if options["note"]
          puts "Committed version: #{app.version}"
          if options["deploy"]
            KRL_CMD::Deploy.go({"version" => app.version})
          end
        rescue KRLParseError => e
          puts "Unable to parse your krl."
          puts "Errors:"
          puts e.parse_errors
        end
      else
        raise "Unable to find file: #{krl_file}"
      end
    end
  end
end
