module KRL_CMD
  class Commit
    def self.go(args)
      require LIB_DIR + 'common'
      begin 
        require "growl"
        growl = true;
      rescue
        puts "No growl notifications"
        growl = false;
      end
      app = KRL_COMMON::get_app
      krl_file = File.join(Dir.pwd, app.application_id + ".krl")
      if File.exists?(krl_file)
        begin
          if growl 
            msg = Growl.new :title => "#{app.application_id}", :message => "Commiting code...", :image => "/kynetx-x.png"
            msg.run
          end
          app.krl = File.open(krl_file, 'r') { |f| f.read }
	  			app.set_version_note(app.version, args.to_s) if args.to_s != ""
          puts "Committed version #{app.version}"
          if growl
            msg = Growl.new :title => "#{app.application_id}", :message => "Commited version #{app.version}", :image => "/kynetx-x.png"
            msg.run
          end
        rescue KRLParseError => e
          puts "Unable to parse your krl."
          puts "Errors:"
          puts e.parse_errors.join("\n")
          if growl
            msg = Growl.new :title => "#{app.application_id}", :message => e.parse_errors.join("\n"), :image => "/kynetx-x.png"
            msg.run
          end
        end
      else
        raise "Unable to find file: #{krl_file}"
      end
    end
  end
end
