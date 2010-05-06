require LIB_DIR + 'user'
require 'fileutils'

module KRL_CMD
  class Checkout
    def self.go(args)
      ruleset_id = args.to_s
      puts "Checking out: #{ruleset_id}"
      raise "Please specify a ruleset id." if ruleset_id.empty?
      root_dir = Dir.pwd + "/#{ruleset_id}"
      raise "Directory already exists." if File.exists?(root_dir)
      user = User.new
      app = user.find_application({:application_id => ruleset_id})
      
      puts "Creating directory: #{root_dir}"
      FileUtils.mkdir root_dir
      app_details = {
        :name => app.name,
        :ruleset_id => app.application_id,
        :role => user.owns_current? ? "owner" : "developer"
      }
      File.open(root_dir + "/.app", "w") { |f| f.print(app_details.to_yaml) }
      File.open(root_dir + "/#{ruleset_id}.krl", "w") { |f| f.print(app.krl) }

      
    end
  end
end