require 'terminal-table/import'
module KRL_COMMON
  def self.pretty_table(collection, fields, limit=0)
    ptable = table do |t|
      
      t.headings = fields.collect{ |h| h[:field] }
      counter = 0
      collection.each do |c|
        row = []
        fields.each do |f|
          row << f[:value].call(c)
        end
        t << row
        counter += 1
        break if limit > 0 && limit == counter
      end
      
    end
    puts ptable
  end
  
  def self.get_app(version="development")
    require LIB_DIR + "user"
    begin
      root_dir = Dir.pwd
      raise "Please re-checkout your app or make sure you are in the root directory of an app." unless File.exists?(File.join(root_dir, ".app"))
      config_file = File.join(root_dir, '.app')
      raise "Unable to get the app information. You need to recheckout your app." unless File.exists?(config_file)
      config = YAML::load_file(config_file)
      user = KRL_CMD::User.new
      app = user.find_application(:application_id => config[:ruleset_id], :version => version)
      return app
    rescue Exception => e
      raise "Unable to get app information. #{e.message}"
    end

  end
  
end
