require 'fileutils'
require 'base64'
require 'net/http'
require 'uri'
require 'json'
require 'launchy'

module KRL_CMD
  class Generate
    include Thor::Shell
    def self.go(endpoint, options)
      g = self.new(endpoint,options)
    end
      
    def initialize(endpoint, options)
      @shell = Basic.new
      @endpoint = endpoint
      @environment = options["environment"]
      @use_defaults = options["defaults"]
      @force = options["force"]
      @app = KRL_COMMON::get_app  
      @user = KRL_CMD::User.new
      endpoints = {
        "firefox" => lambda {gen_extension},
        "chrome" => lambda {gen_extension},
        "ie" => lambda {gen_extension},
        "bookmarklet" => lambda {gen_bookmarklet},
        "infocard" => lambda {gen_infocard}
      }
      if endpoints[@endpoint]
        endpoints[@endpoint].call
      else
        raise "Unknown endpoint specified (#{@endpoint})"
      end

      
    end
    
    def gen_extension
      puts "Generating Extension (#{@endpoint} - #{@environment})"

      if @use_defaults
        extname, extauthor, extdesc = "", "", ""
      else
        extname = @shell.ask("Name of the extension (#{@app.name}):")
        extauthor = @shell.ask("Name of the author (#{@user.name}):")
        extdesc = @shell.ask("Description:")
      end
     
      opts = {}
      opts[:extname] = extname unless extname.empty? 
      opts[:extauthor] = extauthor unless extauthor.empty? 
      opts[:extdesc] = extdesc unless extdesc.empty?
      opts[:env] = @environment
      opts[:force_build] = @force ? "Y" : "N"
      opts[:format] = 'url'

      ext = @app.endpoint(@endpoint, opts)
      write_file(ext)      
    end
    
    def gen_bookmarklet
      puts "Generating Bookmarklet (#{@environment})"
      bm = ""
      opts = {}
      opts[:env] = @environment
      if ! @use_defaults
        opts[:runtime] = @shell.ask("Runtime to use for the bookmarklet (blank for default):")
      end

      endpoint = @app.endpoint(:bookmarklet, opts)
      
      if endpoint["errors"].empty?
        bm = endpoint["data"]
      else
        raise "Invalid bookmark generated. \n#{endpoint.errors.join("\n")}"
      end
      
      bm_file = File.join(get_endpoint_dir, @environment + "_bookmarklet.html")
      File.open(bm_file, 'w') do |f|
        f.print("<textarea rows='5' cols='100'>#{bm}</textarea><br><br>")
        link = @environment == "prod" ? @app.name : @environment + "_" + @app.name
        f.print("<a href=\"#{bm.gsub('"', '&quot;')}\">#{link}</a>")
      end
      puts "BOOKMARKLET:"
      puts bm
      puts
      puts "Saved bookmarklet to #{bm_file}."
      Launchy::Browser.run('file://' + bm_file)
    end
    
    def gen_infocard
      puts "Generating Infocard (#{@environment})"

      if @use_defaults
        extname = ""
        datasets = ""
      else
        extname = @shell.ask("Name of the infocard (#{@app.name}):")
        datasets = @shell.ask("Datasets:")
      end

      opts = {}
      opts[:extname] = extname unless extname.empty?
      opts[:datasets] = datasets unless datasets.empty?
      opts[:env] = @environment
      opts[:format] = 'url'

      icard = @app.endpoint(:info_card, opts)
      write_file(icard)
    end
    
    private

    def get_endpoint_dir
      dir_name = @environment == "prod" ? "/endpoints" : "/test"
      endpoint_dir = Dir.pwd + dir_name
      FileUtils.mkdir(endpoint_dir) unless File.directory?(endpoint_dir)
      return endpoint_dir
    end
    
    
    def write_file(ext)
      if ext["errors"].empty?
        endpoint_dir = get_endpoint_dir
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
