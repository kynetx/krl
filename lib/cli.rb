module KRL_CMD
  LIB_DIR = File.dirname(__FILE__) + "/../lib/"
  %w(user apps checkout create update versions deploy
     commit show note check generate test info stats).each do |cmd|
    require LIB_DIR + cmd
  end
  require LIB_DIR + 'common'
  

  class CLI < Thor
    
    desc "apps", "Display a list of apps"
    def apps
      KRL_CMD::Apps.go
    end

    desc "checkout [RULESET]", "Creates a directory structure with the rulesets you have checked out."
    #method_option  :type => :string, :required => true
    method_option :title, :type => :boolean, :default => false, :aliases => "-t", :banner => "Include the title in the name of the directory."
    method_option :all, :type => :boolean, :default => false, :aliases => "-a", :banner => "Checkout all of your rulesets into this directory."
    #method_option :ruleset, :type => :string, :default => false, :aliases => "-r", :banner => "Ruleset ID, example: a1x1"
    def checkout(ruleset="")
      if ruleset.empty? && options["all"].nil?
        say "Please specify either --ruleset or --all", :red
        say help "checkout"
      else
        KRL_CMD::Checkout.go(ruleset, options)
      end
    end

    desc "create [NAME]", "Creates a new ruleset and checks it out into the the directory."
    method_option :title, :type => :boolean, :default => false, :aliases => "-t", :banner => "Include the name of the ruleset in the directory name"
    method_option :description, :type => :string, :required => false, :aliases => "-d", :banner => "Description for the ruleset"
    def create(name)
      KRL_CMD::Create.go(name, options)
    end
    
    desc "update", "Updates the krl in the ruleset directory to the a specified version."
    method_option :version, :type => :string, :required => false, :default => "development", :aliases => "-v", :banner => "Version number or 'production' or 'development'"
    method_option :save, :type => :boolean, :default => false, :aliases => '-s', :banner => "Save a copy of the existing .krl file"
    def update
      begin
        KRL_CMD::Update.go(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "versions", "Displays a list of the ruleset versions."
    method_option :limit, :type => :numeric, :default => 0, :aliases => "-l", :banner => "Limit the number of versions to show. 0 will show all available versions."
    def versions
      begin
        KRL_CMD::Versions.go(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "deploy", "Deploys a given version to production. If no version is supplied, the latest version is deployed."
    method_option :version, :type => :numeric, :required => false, :aliases => "-v", :banner => "Version to be deployed."
    def deploy
      begin
        KRL_CMD::Deploy.go(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "commit", "Commits or saves the .krl file to the Kynetx platform."
    method_option :note, :type => :string, :required => false, :aliases => "-n", :banner => "Add a note to the commit"
    method_option :deploy, :type => :boolean, :required => false, :aliases => "-d", :banner => "Deploy the ruleset after it has been committed."
    def commit 
      begin
        KRL_CMD::Commit.go(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "show", "Shows the krl for the ruleset for a given version"
    method_option :version, :type => :string, :default => "development", :aliases => "-v", :banner => "Version of the KRL to show."
    def show
      begin
        KRL_CMD::Show.go(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "note", "Adds a note to a ruleset version"
    method_option :version, :type => :string, :default => "development", :aliases => "-v", :banner => "Version of the KRL to show."
    method_option :note, :type => :string, :required => true, :aliases => "-n", :banner => "Note to be added."
    def note
      begin
        KRL_CMD::Note.go(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "check", "Performs a syntax check of your KRL file."
    method_option :parser, :type => :string, :required => false, :aliases => "-p", :banner => "Full URL to an alternate parser to check the krl against."
    def check
      begin
        KRL_CMD::Check.go(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "generate [ENDPOINT]", "Generates an endpoint from the ruleset. Endpoint must be firefox, chrome, ie, bookmarklet, or infocard."
    method_option :environment, :type => :string, :default => "prod", :aliases => "-e", :banner => "Environment. Must be either 'prod' or 'dev'."
    method_option :defaults, :type => :boolean, :default => true, :aliases => "-d", :banner => "Use the defaults and don't prompt for more information."
    method_option :force, :type => :boolean, :default => false, :aliases => "-f", :banner => "Force a rebuild of the endpoint rather than use the cached copy."
    long_desc <<-D
      Generates an endpoint for the ruleset. Endpoints are placed in the ./endpoints directory
      or ./test directory depending on the environment specified.  Current endpoints available are:
      firefox (Mozilla Firefox), chrome (Google Chrome), ie (Microsoft Internet Explorer), bookmarklet (HTML Bookmarklet), 
      infocard (Info Card, see http://en.wikipedia.org/wiki/Information_Card). 
      Infocards generated here are used in the Azigo Card Selector. 
      See http://www.azigo.com
    D
    def generate(endpoint)
      begin
        KRL_CMD::Generate.go(endpoint, options)
      rescue => e
        say e.message, :red
      end
    end

    desc "test", "Test has been deprecated, use 'generate -e dev'"
    def test
      say "'test' has been deprecated. Use 'generate -e dev'", :red
      help "generate"
    end

    desc "info", "Display information about a ruleset"
    method_option :app, :type => :string, :required => false, :aliases => "-a", :banner => "Ruleset for which to show information"
    def info
      begin
        KRL_CMD::Info.go(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "stats", "Display basic stats for the ruleset. NOTE: You must be the owner of the app to see stats."
    method_option :range, :type => :string, :default => "previous_day", :aliases => "-r", :banner => "Specify the range for the stats." 
    method_option :format, :type => :string, :default => "table", :aliases => "-f", :banner => "Format of the data. (table, json)"
    def stats
      begin
        KRL_CMD::Stats.kpis(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "stats_interface", "Display the available options for running a stats query."
    def stats_interface
      begin
        KRL_CMD::Stats.interface
      rescue => e
        say e.message, :red
      end
    end

    desc "account_stats", "Display stats for the Kynetx account."
    method_option :range, :type => :string, :default => "previous_day", :aliases => "-r", :banner => "Specify the range for the stats." 
    method_option :format, :type => :string, :default => "table", :aliases => "-f", :banner => "Format of the data. (table, json)"
    def account_stats
      begin
        KRL_CMD::Stats.account_kpis(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "logging", "Displays values logged with explicit logging for the ruleset"
    method_option :range, :type => :string, :default => "previous_day", :aliases => "-r", :banner => "Specify the range for the stats."
    def logging
      begin
        KRL_CMD::Stats.logging(options)
      rescue => e
        say e.message, :red
      end
    end

    desc "stats_query", "Build a custom stats query"
    long_desc <<-D
      Allows you to create a custom query for stats. Queries can be helpful for pulling
      custom or ad-hoc data from the Kynetx data warehouse.

      - Dimensions are fields that can be grouped and specified in a condition.

      - KPIs, or sometimes called Facts, are data that is aggregated and cannot be included in a condition

      - Contitions are specified in key value pairs, for example: 'dim:value' separated by a space.

      - Ranges are preset date ranges for the query. All queries have a default range of 'previous_day'.

      All available Dimensions, KPIs, and Ranges can be seen by running 'krl stats_interface'

      Examples:\n
      krl stats_query -k brse -d ruleset day -r last_thirty_days \n
      krl stats_query -k rse brse -d am_pm hour interval_15 -r current_month -c hour:00 \n
      krl stats_query -k rse brse -d am_pm hour interval_15 -r current_month -c hour:00 interval_15:00\n
      krl stats_query -k brse -d day_of_week day -r current_month -c day_of_week_abbr:Wed

      All data is available as both a table or as JSON. To specify the format, use the --format option.

    D
    method_option :kpis, :type => :array, :required => true, :aliases => "-k", :banner => ""
    method_option :dims, :type => :array, :required => true, :aliases => "-d", :banner => ""
    method_option :conditions, :type => :hash, :required => false, :aliases => "-c", :banner => "Conditions for the query as 'dim:value'."
    method_option :range, :type => :string, :default => "previous_day", :aliases => "-r", :banner => "Specify the range for the stats." 
    method_option :format, :type => :string, :default => "table", :aliases => "-f", :banner => "Format of the data. (table, json)"
    def stats_query
      begin
        KRL_CMD::Stats.query(options)
      rescue => e
        say e.message, :red
      end
    end


  end


end
