require 'fileutils'

module KRL_CMD
  class Checkout

    def self.go(ruleset, options)
      begin
        c = self.new(ruleset, options)
        c.checkout
      rescue Exception => e
        puts e.message
        ap e.backtrace if $DEBUG
      end
    end

    def initialize(ruleset, options)
      @user = User.new
      @ruleset = ruleset
      @include_title = options["title"] 
      @all = options["all"]
      app = KRL_COMMON::get_app rescue nil
			raise "You are already in an application directory: #{app.application_id}" if app
    end

    def checkout

      if @all
        @user.applications["apps"].each do |app|
          begin
            @ruleset = app["appid"]
            do_checkout
          rescue => e
            puts e.message
          end
        end
      else
        do_checkout
      end

      
    end

    private

    def do_checkout
      app = @user.find_application({:application_id => @ruleset})
      if app
        dir_name = @include_title && app.name ? "#{@ruleset}-#{app.name}" : @ruleset
        puts "Checking out: #{dir_name}"
        root_dir = Dir.pwd + "/#{dir_name}"
        raise "Directory already exists (#{root_dir})." if File.exists?(root_dir)
        
        puts "Creating directory: #{root_dir}"
        FileUtils.mkdir root_dir
        app_details = {
          :name => app.name,
          :ruleset_id => app.application_id,
          :role => @user.owns_current? ? "owner" : "developer"
        }
        File.open(root_dir + "/.app", "w") { |f| f.print(app_details.to_yaml) }
        File.open(root_dir + "/#{app.application_id}.krl", "w") { |f| f.print(app.krl) }
      else
        puts "Unable to find ruleset #{@ruleset}. You probably don't have permission to check it out."
      end
    end
  end
end
