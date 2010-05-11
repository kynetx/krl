module KRL_CMD
  class Info
    def self.go(args)
      require LIB_DIR + 'user'
      require LIB_DIR + 'common'
      require 'pp'
      user = User.new
      app_id = nil
      if(args.length > 0)
        app_id = args[0]
      else
        app_id = KRL_COMMON::get_app().application_id rescue nil
      end
      raise "Unable to determine the application id. use 'krl help' for more information." unless app_id
      
      app_info = user.api.get_app_info(app_id)
      app_details = user.api.get_app_details(app_id)

      puts "Application Users"
      KRL_COMMON::pretty_table(app_details["users"], [
        {:field => "Login", :value => lambda { |r| r["username"] }},
        {:field => "Last Name", :value => lambda { |r| r["lastname"] }},
        {:field => "First Name", :value => lambda { |r| r["firstname"].to_s }},
        {:field => "Role", :value => lambda { |r| r["role"] }}
      ])
      puts ""
      puts ""

      puts "Production Version"
      if(app_info["production"])
        puts "Current Production version is #{app_info["production"]["version"]} IE Guid : #{app_details["guid"]}"
      else
        puts "No Production version"
      end
      puts ""
      puts ""

      puts "Development Version"
      if(app_info["development"])
        puts "Current Production version is #{app_info["development"]["version"]} IE Guid : #{app_details["guid"]}"
      else
        puts "No Production version"
      end
      puts ""
      puts ""

      KRL_COMMON::pretty_table(app_info["versions"], [
        {:field => "Login", :value => lambda { |r| r["login"] }},
        {:field => "Name", :value => lambda { |r| r["name"] }},
        {:field => "Created", :value => lambda { |r| r["created"].to_s }},
        {:field => "Version", :value => lambda { |r| r["version"] }},
        {:field => "Note", :value => lambda { |r| r["note"] }}
      ])
    end
  end
end