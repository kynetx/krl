require 'fileutils'
require 'base64'
require 'net/http'
require 'uri'
require 'json'
require 'launchy'

module KRL_CMD
  class Generate
    def self.go(args)
      raise "Please specify an endpoint to generate" if args.to_s.empty?   
      type = args.shift
      endpoints = {
        "firefox" => lambda {gen_extension(type, args)},
        "chrome" => lambda {gen_extension(type, args)},
        "ie" => lambda {gen_extension(type, args)},
        "bookmarklet" => lambda {gen_bookmarklet(args)},
        "infocard" => lambda {gen_infocard(args)}
      }
      if endpoints[type]
        endpoints[type].call
      else
        raise "Unknown endpoint specified (#{type})"
      end
      
    end
    
    def self.gen_extension(type, args, env='prod')
      puts "Generating Extension (#{type.to_s}) #{args.join(', ')}"
      # ext = app.extension(type, args[0] || "", args[1] || "", args[2] || "" )
      # write_file(ext, "prod")   
     
      opts = {}
      opts[:extname] = args[0] if args[0]
      opts[:extauthor] = args[1] if args[1]
      opts[:extdesc] = args[2] if args[2]
      opts[:env] = env
      opts[:format] = 'url'

      ext = app.endpoint(type, opts)
      write_file(ext, env)      
    end
    
    def self.gen_bookmarklet(args, env="prod")
      puts "Generating Bookmarklet (#{env})"
      bm = ""
      opts = {}
      opts[:env] = env
      opts[:runtime] = args.to_s unless args.to_s.empty?

      endpoint = app.endpoint(:bookmarklet, opts)
      
      if endpoint["errors"].empty?
        bm = endpoint["data"]
      else
        raise "Invalid bookmark generated. \n#{endpoint.errors.join("\n")}"
      end
      
      bm_file = File.join(get_endpoint_dir(env), env + "_bookmarklet.html")
      File.open(bm_file, 'w') do |f|
        f.print("<textarea rows='5' cols='100'>#{bm}</textarea><br><br>")
        link = env == "prod" ? app.name : env + "_" + app.name
        f.print("<a href=\"#{bm.gsub('"', '&quot;')}\">#{link}</a>")
      end
      puts "BOOKMARKLET:"
      puts bm
      puts
      puts "Saved bookmarklet to #{bm_file}."
      Launchy::Browser.run('file://' + bm_file)
    end
    
    def self.gen_infocard(args, env="prod")
      raise "You must specify a name for the card" if args.empty?
      puts "Generating Infocard (#{env})"
      opts = {}
      opts[:extname] = args[0] if args[0]
      opts[:datasets] = args[1] if args[1]
      opts[:env] = env
      opts[:format] = 'url'

      icard = app.endpoint(:info_card, opts)
      write_file(icard, env)
    end
    
    def self.app
      return @@app if defined?@@app
      require LIB_DIR + 'common'
      @@app = KRL_COMMON::get_app 
      return @@app
    end
    
    def self.get_endpoint_dir(env)
      dir_name = env == "prod" ? "/endpoints" : "/test"
      endpoint_dir = Dir.pwd + dir_name
      FileUtils.mkdir(endpoint_dir) unless File.directory?(endpoint_dir)
      return endpoint_dir
    end
    
    def self.write_file(ext, env)
      if ext["errors"].empty?
        endpoint_dir = get_endpoint_dir(env)
        ext_file_name = File.join(endpoint_dir, ext["file_name"])
        url = URI.parse(ext["data"])

        # Download the file
        puts "Downloading endpoint from #{ext["data"]} to #{ext_file_name}"
        Net::HTTP.start(url.host, url.port) { |http|
          resp = http.get url.path
          open(ext_file_name, "wb") do |file|
            file.write(resp.body)
          end
        }
        puts "Endpoint was created: #{ext_file_name}"
      else
        raise ext["errors"].join("\n")
      end
    end
  end
end
