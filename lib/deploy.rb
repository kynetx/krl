module KRL_CMD
  class Deploy
    def self.go(args)
      require LIB_DIR + 'common'
      begin
        require "growl"
        growl = true
      rescue 
        growl = false
      end
      app = KRL_COMMON::get_app
      if growl
        msg = Growl.new :title => "#{app.application_id}", :message => "Deploying code...", :image => "/kynetx-x.png"
        msg.run
      end
      prod_version = args.to_s.empty? ? app.version : args.to_s.to_i
      app.production_version = prod_version
      puts "Deployed version: #{app.production_version}"
      if growl
        msg = Growl.new :title => "#{app.application_id}", :message => "Deployed version #{app.production_version}", :image => "/kynetx-x.png"
        msg.run
      end
    end
  end
end
