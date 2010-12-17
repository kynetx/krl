require 'terminal-table/import'
require 'net/http'

module KRL_COMMON
  def self.pretty_table(collection, fields, limit=0, limit_last=false)
    raise "Nothing to present" if collection.empty?
    ptable = table do |t|
      
      t.headings = fields.collect{ |h| h[:field] }
      counter = 0
      collection.each do |c|
        show_row = true

        if limit_last && limit > 0
          # This will make it so that the last items in the table are
          # shown rather than the first when a limit is specified.
          show_row = (counter + 1) > (collection.length - limit)
        end

        if show_row
          row = []
          fields.each do |f|
            row << f[:value].call(c) if show_row
          end
          t << row
        end
        counter += 1
        break if limit > 0 && limit == counter && ! limit_last
      end
      
    end
    puts ptable
  end
  
  def self.get_app(version="development")
    begin
      root_dir = Dir.pwd
      raise "Please re-checkout your ruleset or make sure you are in the root directory of a ruleset." unless File.exists?(File.join(root_dir, ".app"))
      config_file = File.join(root_dir, '.app')
      raise "Unable to get the app information. You need to recheckout your app." unless File.exists?(config_file)
      config = YAML::load_file(config_file)
      user = KRL_CMD::User.new
      app = user.find_application(:application_id => config[:ruleset_id], :version => version)
      return app
    rescue Exception => e
      raise "Unable to get ruleset information. #{e.message}"
    end

  end

  def self.long_post_form(url, params)
    req = Net::HTTP::Post.new(url.path)
    req.form_data = params
    req.basic_auth url.user, url.password if url.user
    Net::HTTP.new(url.host, url.port).start {|http|
      http.read_timeout = 120
      http.request(req)
    }
  end

  
end
